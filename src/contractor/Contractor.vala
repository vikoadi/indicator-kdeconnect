namespace KDEConnectIndicator {
    public class DeviceDialog : Gtk.Dialog {
        private Gtk.TreeView tv;
        private Gtk.Widget select_button;
        public DeviceDialog (string filename) {
            this.title = "Send to";
            this.border_width = 10;
            set_default_size (500, 400);

            var content = get_content_area () as Gtk.Box;
            content.pack_start (new Gtk.Label (filename), false, true, 10);
            tv = new Gtk.TreeView ();
            tv.headers_visible = false;
            Gtk.CellRendererText cell = new Gtk.CellRendererText ();
            tv.insert_column_with_attributes (-1,"Device",cell,"text",0);

            content.pack_start (tv);
            add_button ("Cancel", Gtk.ResponseType.CANCEL);
            select_button = add_button ("Send", Gtk.ResponseType.OK);
            show_all ();
            this.response.connect (on_response);

            tv.cursor_changed.connect (()=>{
                this.select_button.sensitive = (get_selected()>=0);
            });
        }
        public void set_list (Gtk.ListStore l) {
            tv.set_model (l);
        }
        public int get_selected () {
            Gtk.TreePath path;
            Gtk.TreeViewColumn column;
            tv.get_cursor (out path, out column);
            if (path == null)
                return -1;
            return int.parse (path.to_string ());
        }
        private void on_response (Gtk.Dialog source, int id) {
            if (id==Gtk.ResponseType.CANCEL)
                destroy ();
        }
    }
    int main (string[] args) {
        Gtk.init (ref args);

        File f = File.new_for_commandline_arg (args[1]);
        if (!f.query_exists ()) {
            message ("file doesnt exist");
            var msd = new Gtk.MessageDialog (null, Gtk.DialogFlags.MODAL,
                    Gtk.MessageType.WARNING, Gtk.ButtonsType.OK,
                    "File not found");
            msd.destroy.connect (Gtk.main_quit);
            msd.show ();
            msd.run ();

            return -1;
        }

        Gtk.ListStore list_store;
        DBusConnection conn;

        try {
            conn = Bus.get_sync (BusType.SESSION);
        } catch (Error e) {
            message (e.message);
            return -1;
        }

        string[] id_list = {};
        try {
            var return_variant = conn.call_sync (
                    "org.kde.kdeconnect",
                    "/modules/kdeconnect",
                    "org.kde.kdeconnect.daemon",
                    "devices",
                    new Variant ("(b)", true),
                    null,
                    DBusCallFlags.NONE,
                    -1,
                    null
                    );
            Variant i = return_variant.get_child_value (0);
            id_list = i.dup_strv ();
        } catch (Error e) {
            message (e.message);
        }
        list_store = new Gtk.ListStore (1,typeof(string));
        var device_list = new SList<Device> ();
        foreach (string id in id_list) {
            var d = new Device ("/modules/kdeconnect/devices/"+id);
            if (d.is_reachable () && d.is_paired ()) {
                device_list.append (d);
                Gtk.TreeIter iter;
                list_store.append (out iter);
                message (d.name);
                list_store.set (iter, 0, d.name);
            }
        }

        var d = new DeviceDialog (f.get_basename ());
        d.set_list (list_store);
        if (d.run () == Gtk.ResponseType.OK) {
            var selected = d.get_selected ();
            var selected_dev = device_list.nth_data (selected);
            selected_dev.send_file (f.get_uri ());
        }
        d.destroy.connect (Gtk.main_quit);
        d.show_all ();

        return 0;
    }
}

namespace KDEConnectIndicator {
    public class FirstTimeWizard : Gtk.Window {
        private KDEConnectManager manager;
        private SList<Device> list;
        public FirstTimeWizard (KDEConnectManager manager) {
            this.default_width = 600;
            this.default_height = 500;
            this.manager = manager;

            var stack = new Gtk.Stack ();
            stack.margin = 20;
            stack.homogeneous = true;
            stack.set_transition_duration (1000);
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT);

            stack.add_named (create_connect_page (), "connect");
            stack.add_named (create_pair_page (), "pair");
            stack.add_named (create_finish_page (), "finish");

            stack.visible_child_name = "finish";

            this.add (stack);
            this.show_all ();

            list = new SList<Device> ();
            manager.device_added.connect ((id)=>{
                if (stack.visible_child_name == "connect"){
                    stack.visible_child_name = "pair";
                    var d = new Device (id);
                    d.pairing_successful.connect (()=>{
                        if (stack.visible_child_name == "pair")
                            stack.visible_child_name = "finish";
                    });
                    list.append (d);
                }
            }); }

        private Gtk.Widget create_connect_page () {
            return create_box (
                    Gtk.Orientation.HORIZONTAL,

                    "<b>Are you ready for your first device pairing?</b>\n\n"+
                    "Now connect your devices using wifi connection.\n"+
                    "Tethering should work too!\n\n"+
                    "Launch KDE Connect in your Android which you can download from "+
                    """<a href="https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp">"""+
                    "https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp</a>",

                    Constants.DATADIR+"/icons/hicolor/256x256/apps/kdeconnect.png");

        }

        private Gtk.Widget create_pair_page () {
            return create_box (
                    Gtk.Orientation.VERTICAL,

                    "Everytime there is a new device connected, a new indicator will appear in your panel.\n"+
                    "There, you can pair and see its status\n\n"+
                    "<b>Now try to pair your device</b>",

                    Constants.PKGDATADIR+"/indicator.jpg");
        }

        private Gtk.Widget create_finish_page () {
            return create_box (
                    Gtk.Orientation.VERTICAL,

                    "<b>Great, your device is all set</b>\n\n"+
                    "Finally you can enable KDEConnect Indicator "+
                    "as startup application from your Autostart setting.\n\n"+
                    "enjoy!",

                    Constants.PKGDATADIR+"/startup.jpg");
        }
        private Gtk.Box create_box (Gtk.Orientation orientation, string markup, string image_path) {
            var box = new Gtk.Box (orientation, 10);

            box.pack_start (new Gtk.Image.from_file (image_path));

            var l = new Gtk.Label (null);
            l.set_markup (markup);
            l.wrap = true;
            l.justify = Gtk.Justification.LEFT;
            box.pack_start (l);

            return box;
        }
    }
}

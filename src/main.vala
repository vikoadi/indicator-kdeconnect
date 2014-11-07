namespace KDEConnectIndicator {
    public class Application : Gtk.Application {
        public Application () {
            Object (application_id: "com.vikoadi.kdeconnectindicator",
                    flags: ApplicationFlags.FLAGS_NONE);

        }

        protected override void startup () {
            base.startup ();

            // TODO: need to make sure kdeconnectd daemon is running
            int max_trying = 3;
            while (get_dbus_name () == null) {
                if (max_trying <= 0) {
                    var msg = new Gtk.MessageDialog (
                            null, Gtk.DialogFlags.MODAL,
                            Gtk.MessageType.WARNING,
                            Gtk.ButtonsType.OK,
                            "cannot connect to KDE Connect DBus service"
                            );
                    msg.response.connect(()=>{this.quit_mainloop();});

                    msg.show_all ();
                    msg.run ();
                    return;
                }
                Thread.usleep (500);
                message ("retrying to find KDE Connect DBus service");
                max_trying--;
            }

            if (max_trying > 0) {
                var manager = new KDEConnectManager ();
            }

            new MainLoop ().run ();
        }

        protected override void activate () {
        }

        // kdeconnect's dbus name is changed in between 0.5 to 0.7
        private string? get_dbus_name () {
            // TODO:implement
            return null;
        }
    }
    int main (string[] args) {
        Application app = new Application ();
        return app.run (args);
    }
}

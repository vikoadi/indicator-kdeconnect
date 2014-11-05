namespace KDEConnectIndicator {
    public class Application : Gtk.Application {
        public Application () {
            Object (application_id: "com.vikoadi.kdeconnectindicator",
                    flags: ApplicationFlags.FLAGS_NONE);

        }

        protected override void startup () {
            base.startup ();
            var manager = new KDEConnectManager ();
            var indicator = new DeviceIndicator (this,
                    "/modules/kdeconnect/devices/603008be5222571f");
            new MainLoop ().run ();
        }

        protected override void activate () {
        }
    }
    int main (string[] args) {
        Application app = new Application ();
        return app.run (args);
    }
}

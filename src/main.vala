/* Copyright 2014 KDE Connect Indicator Developers
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */
namespace KDEConnectIndicator {
    public class Application : Gtk.Application {
        private KDEConnectManager manager;
        private FirstTimeWizard ftw;

        public Application () {
            Object (application_id: "com.vikoadi.kdeconnectindicator",
                    flags: ApplicationFlags.FLAGS_NONE);

        }

        protected override void startup () {
            base.startup ();

            manager = new KDEConnectManager ();
            var startup = new StartupManager ();

            if (ftw == null && manager.get_devices_number () == 0 && !startup.is_installed ()) {
                ftw = new FirstTimeWizard (manager);
                startup.install ();
            }

            new MainLoop ().run ();
        }

        protected override void activate () {
            if (ftw == null && manager.get_devices_number () == 0)
                new FirstTimeWizard (manager);
        }
    }
    int main (string[] args) {
        Application app = new Application ();
        return app.run (args);
    }
}

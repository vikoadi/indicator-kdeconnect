/* Copyright 2014 KDE Connect Indicator Developers
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */
namespace KDEConnectIndicator {
    public class Application : Gtk.Application {
        public Application () {
            Object (application_id: "com.vikoadi.kdeconnectindicator",
                    flags: ApplicationFlags.FLAGS_NONE);

        }

        protected override void startup () {
            base.startup ();

            var manager = new KDEConnectManager ();

            var ftw = new FirstTimeWizard (manager);

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

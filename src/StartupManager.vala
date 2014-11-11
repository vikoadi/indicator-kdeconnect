namespace KDEConnectIndicator {
    public class StartupManager {
        private const string desktop_file = "indicator-kdeconnect.desktop";
        private string prefix_dir;
        private string autostart_folder;
        private File startup_file;
        public StartupManager () {
            autostart_folder = Environment.get_user_config_dir ()+"/autostart/";
            startup_file = File.new_for_path (autostart_folder+desktop_file);
            prefix_dir = "/usr/share"; // TODO: get prefix dir from CMAKE
        }
        public bool is_installed () {
            return startup_file.query_exists ();
        }
        public void install () {
            var desktop_file = File.new_for_path (
                    Constants.DATADIR +
                    "/applications/" +
                    desktop_file);

            if (desktop_file.query_exists ()) {
                try {
                    var startup_folder = startup_file.get_parent ();
                    if (!startup_folder.query_exists ())
                        startup_folder.make_directory_with_parents ();
                    if (desktop_file.copy (startup_file, FileCopyFlags.NONE))
                        message ("autostart file installed in %s",
                            startup_file.get_path ());
                } catch (Error e) {
                    message (e.message);
                }
            } else
                message ("cant find .desktop file in %s", desktop_file.get_path ());
        }
    }
}

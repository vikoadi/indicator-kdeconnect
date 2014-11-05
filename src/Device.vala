namespace KDEConnectIndicator {
    public class Device {
        private DBusConnection conn;
        private string path;
        private SList<uint> subs_identifier;

        public string name {
            get {
                // TODO : How to read dbus properties using DBusConnection?
                /*
                try {
                    Variant return_variant = conn.get (
                            "org.kde.kdeconnect",
                            path,
                            "org.kde.kdeconnect.device",
                            "name"
                            );
                    Variant i = return_variant.get_child_value (0);
                    if (i!=null)
                        return i.get_string ();
                } catch (Error e) {
                    message (e.message);
                }
                */
                return "";
            }
        }
        public int battery {
            get {
                try {
                    var return_variant = conn.call_sync (
                            "org.kde.kdeconnect",
                            path,
                            "org.kde.kdeconnect.device.battery",
                            "charge",
                            null,
                            null,
                            DBusCallFlags.NONE,
                            -1,
                            null
                            );
                    Variant i = return_variant.get_child_value (0);
                    if (i!=null)
                        return i.get_int32 ();
                } catch (Error e) {
                    message (e.message);
                }
                return 0;
            }
        }

        public Device (string path) {
            message ("device : %s",path);
            this.path = path;

            try {
                conn = Bus.get_sync (BusType.SESSION);
            } catch (Error e) {
                message (e.message);
            }

            uint id;
            subs_identifier = new SList<uint> ();
            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.device",
                    "pairingFailed",
                    path,
                    null,
                    DBusSignalFlags.NONE,
                    string_signal_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.device",
                    "pairingSuccesful",
                    path,
                    null,
                    DBusSignalFlags.NONE,
                    void_signal_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.device",
                    "reachableStatusChanged",
                    path,
                    null,
                    DBusSignalFlags.NONE,
                    void_signal_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.device",
                    "unpaired",
                    path,
                    null,
                    DBusSignalFlags.NONE,
                    void_signal_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.device.battery",
                    "chargeChanged",
                    path,
                    null,
                    DBusSignalFlags.NONE,
                    int32_signal_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.device.battery",
                    "stateChanged",
                    path,
                    null,
                    DBusSignalFlags.NONE,
                    boolean_signal_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.device.sftp",
                    "mounted",
                    path,
                    null,
                    DBusSignalFlags.NONE,
                    void_signal_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.device.sftp",
                    "unmounted",
                    path,
                    null,
                    DBusSignalFlags.NONE,
                    void_signal_cb
                    );
            subs_identifier.append (id);
        }
        ~Device () {
            foreach (uint i in subs_identifier) {
                conn.signal_unsubscribe (i);
            }
        }
        public void send_file (string url) {
            try {
                conn.call_sync (
                        "org.kde.kdeconnect",
                        path+"/share",
                        "org.kde.kdeconnect.device.share",
                        "shareUrl",
                        new Variant ("(s)",url),
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
            } catch (Error e) {
                message (e.message);
            }
        }
        public bool is_paired () {
            try {
                var return_variant = conn.call_sync (
                        "org.kde.kdeconnect",
                        path,
                        "org.kde.kdeconnect.device",
                        "isPaired",
                        null,
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
                Variant i = return_variant.get_child_value (0);
                if (i!=null)
                    return i.get_boolean ();
            } catch (Error e) {
                message (e.message);
            }
            return false;
        }
        public bool is_reachable () {
            try {
                var return_variant = conn.call_sync (
                        "org.kde.kdeconnect",
                        path,
                        "org.kde.kdeconnect.device",
                        "isReachable",
                        null,
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
                Variant i = return_variant.get_child_value (0);
                if (i!=null)
                    return i.get_boolean ();
            } catch (Error e) {
                message (e.message);
            }
            return false;
        }
        public bool is_charging () {
            try {
                var return_variant = conn.call_sync (
                        "org.kde.kdeconnect",
                        path,
                        "org.kde.kdeconnect.device.battery",
                        "isCharging",
                        null,
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
                Variant i = return_variant.get_child_value (0);
                if (i!=null)
                    return i.get_boolean ();
            } catch (Error e) {
                message (e.message);
            }
            return false;
        }
        public void request_pair () {
            try {
                conn.call_sync (
                        "org.kde.kdeconnect",
                        path,
                        "org.kde.kdeconnect.device",
                        "requestPair",
                        null,
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
            } catch (Error e) {
                message (e.message);
            }
        }
        public void unpair () {
            try {
                conn.call_sync (
                        "org.kde.kdeconnect",
                        path,
                        "org.kde.kdeconnect.device",
                        "unpair",
                        null,
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
            } catch (Error e) {
                message (e.message);
            }
        }
        public void browse () {
            if (is_mounted ())
                open_file (mount_point);
            else {
                mount();
                open_file (mount_point);
            }
        }
        public bool is_mounted () {
            try {
                var return_variant = conn.call_sync (
                        "org.kde.kdeconnect",
                        path+"/sftp",
                        "org.kde.kdeconnect.device.sftp",
                        "isMounted",
                        null,
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
                Variant i = return_variant.get_child_value (0);
                if (i!=null)
                    return i.get_boolean ();
            } catch (Error e) {
                message (e.message);
            }
            return false;
        }
        private string _mount_point;
        private string mount_point {
            get {
                try {
                    var return_variant = conn.call_sync (
                            "org.kde.kdeconnect",
                            path+"/sftp",
                            "org.kde.kdeconnect.device.sftp",
                            "mountPoint",
                            null,
                            null,
                            DBusCallFlags.NONE,
                            -1,
                            null
                            );
                    Variant i = return_variant.get_child_value (0);
                    _mount_point= i.dup_string ();
                    return _mount_point;
                } catch (Error e) {
                    message (e.message);
                }
                return ""; //TODO : maybe return /home/vikoadi/.kde/share/apps/kdeconnect/
            }
        }
        public void mount () {
            try {
                conn.call_sync (
                        "org.kde.kdeconnect",
                        path+"/sftp",
                        "org.kde.kdeconnect.device.sftp",
                        "mount",
                        null,
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
            } catch (Error e) {
                message (e.message);
            }
        }
        public void unmount () {
            try {
                conn.call_sync (
                        "org.kde.kdeconnect",
                        path+"/sftp",
                        "org.kde.kdeconnect.device.sftp",
                        "unmount",
                        null,
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
            } catch (Error e) {
                message (e.message);
            }
        }
        public void int32_signal_cb (DBusConnection con, string sender, string object,
                string interface, string signal_name, Variant parameter) {
            int param = (int)parameter.get_child_value (0).get_int32 ();
            switch (signal_name) {
                case "chargeChanged" :
                    charge_changed ((int)param);
                    break;
            }
        }
        public void void_signal_cb (DBusConnection con, string sender, string object,
                string interface, string signal_name, Variant parameter) {
            switch (signal_name) {
                case "pairingSuccesful" :
                    pairing_successful ();
                    break;
                case "reachableStatusChanged" :
                    pairing_successful ();
                    break;
                case "unpaired" :
                    unpaired ();
                    break;
                case "mounted" :
                    mounted ();
                    break;
                case "unmounted" :
                    unmounted ();
                    break;
            }
        }
        public void boolean_signal_cb (DBusConnection con, string sender, string object,
                string interface, string signal_name, Variant parameter) {
            bool param = parameter.get_child_value (0).get_boolean ();
            switch (signal_name) {
                case "stateChanged" :
                    state_changed (param);
                    break;
            }
        }
        public void string_signal_cb (DBusConnection con, string sender, string object,
                string interface, string signal_name, Variant parameter) {
            string param = parameter.get_child_value (0).get_string ();
            switch (signal_name) {
                case "pairingFailed" :
                    pairing_failed (param);
                    break;
            }
        }
        private bool open_file (string path) {
            var file = File.new_for_path (path);
            try {
                var handler = file.query_default_handler (null);
                var list = new List<File> ();
                list.append (file);
                return handler.launch (list, null);
            } catch (Error e) {
                message (e.message);
            }
            return false;
        }
        public signal void charge_changed (int charge);
        public signal void pairing_failed (string error);
        public signal void pairing_successful ();
        public signal void reachable_status_changed ();
        public signal void unpaired ();
        public signal void mounted ();
        public signal void unmounted ();
        public signal void state_changed (bool state);
    }
}


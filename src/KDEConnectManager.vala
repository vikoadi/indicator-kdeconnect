namespace KDEConnectIndicator {
    public class KDEConnectManager {
        private DBusConnection conn;
        private SList<DeviceIndicator> device_list;
        private SList<uint> subs_identifier;

        public KDEConnectManager () {
            try {
                conn = Bus.get_sync (BusType.SESSION);
            } catch (Error e) {
                message (e.message);
            }

            device_list = new SList<DeviceIndicator> ();
            populate_devices ();

            uint id;
            subs_identifier = new SList<uint> ();

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.daemon",
                    "deviceAdded",
                    "/modules/kdeconnect",
                    null,
                    DBusSignalFlags.NONE,
                    device_added_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.daemon",
                    "deviceRemoved",
                    "/modules/kdeconnect",
                    null,
                    DBusSignalFlags.NONE,
                    device_removed_cb
                    );
            subs_identifier.append (id);

            id = conn.signal_subscribe (
                    "org.kde.kdeconnect",
                    "org.kde.kdeconnect.daemon",
                    "deviceVisibilityChanged",
                    "/modules/kdeconnect",
                    null,
                    DBusSignalFlags.NONE,
                    device_visibility_changed_cb
                    );
            subs_identifier.append (id);

        }
        ~KDEConnectManager () {
            foreach (uint i in subs_identifier)
                conn.signal_unsubscribe (i);
        }

        private void populate_devices () {
            string[] devs = devices ();

            foreach (string dev in devs) {
                string path = "/modules/kdeconnect/devices/"+dev;
                var d = new DeviceIndicator (path);
                device_list.append (d);
            }
        }
        private void add_device (string path) {
            var d = new DeviceIndicator (path);
            device_list.append (d);
        }
        private void remove_device (string path) {
            foreach (DeviceIndicator d in device_list) {
                if (d.path == path) {
                    device_list.remove (d);
                    break;
                }
            }
        }
        private string[] devices (bool only_reachable = false) {
            string[] list = {};
            try {
                var return_variant = conn.call_sync (
                        "org.kde.kdeconnect",
                        "/modules/kdeconnect",
                        "org.kde.kdeconnect.daemon",
                        "devices",
                        new Variant ("(b)", only_reachable),
                        null,
                        DBusCallFlags.NONE,
                        -1,
                        null
                        );
                Variant i = return_variant.get_child_value (0);
                return i.dup_strv ();
            } catch (Error e) {
                message (e.message);
            }
            return list;
        }

        private void device_added_cb (DBusConnection con, string sender, string object,
                string interface, string signal_name, Variant parameter) {
            string param = parameter.get_child_value (0).get_string ();
            var path = "/modules/kdeconnect/devices/"+param;
            add_device (path);
            device_added (path);
        }
        private void device_removed_cb (DBusConnection con, string sender, string object,
                string interface, string signal_name, Variant parameter) {
            string param = parameter.get_child_value (0).get_string ();
            var path = "/modules/kdeconnect/devices/"+param;
            remove_device (path);
            device_added (path);
        }
        private void device_visibility_changed_cb (DBusConnection con, string sender, string object,
                string interface, string signal_name, Variant parameter) {
            string param = parameter.get_child_value (0).get_string ();
            bool v = parameter.get_child_value (1).get_boolean ();
            message ("visibility changed %s:%s", param, v?"visible":"invisible");
            device_visibility_changed (param, v);
        }

        public signal void device_added (string id);
        public signal void device_removed (string id);
        public signal void device_visibility_changed (string id, bool visible);
    }
}


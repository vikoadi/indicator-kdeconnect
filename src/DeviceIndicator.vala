/* Copyright 2014 KDE Connect Indicator Developers
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */
namespace KDEConnectIndicator {
    public class DeviceIndicator {
        private const string ICON_NAME = "phone-symbolic";
        public string path;
        private Device device;
        private Gtk.Menu menu;
        private AppIndicator.Indicator indicator;
        private Gtk.MenuItem name_item;
        private Gtk.MenuItem battery_item;
        private Gtk.MenuItem status_item;
        private Gtk.MenuItem browse_item;
        private Gtk.MenuItem send_item;
        private Gtk.SeparatorMenuItem separator;
        private Gtk.MenuItem pair_item;
        private Gtk.MenuItem unpair_item;
        public DeviceIndicator (string path) {
            this.path = path;
            device = new Device (path);
            menu = new Gtk.Menu ();

            indicator = new AppIndicator.Indicator (
                    path,
                    device.icon_name + "-symbolic",
                    AppIndicator.IndicatorCategory.HARDWARE);

            name_item = new Gtk.MenuItem ();
            menu.append(name_item);
            battery_item = new Gtk.MenuItem();
            menu.append(battery_item);
            status_item = new Gtk.MenuItem ();
            menu.append(status_item);
            menu.append (new Gtk.SeparatorMenuItem ());
            browse_item = new Gtk.MenuItem.with_label ("Browse device");
            menu.append(browse_item);
            send_item = new Gtk.MenuItem.with_label ("Send file");
            menu.append(send_item);
            separator = new Gtk.SeparatorMenuItem ();
            menu.append (separator);
            pair_item = new Gtk.MenuItem.with_label ("Request pairing");
            menu.append(pair_item);
            unpair_item = new Gtk.MenuItem.with_label ("Unpair");
            menu.append(unpair_item);

            menu.show_all ();

            update_visibility ();
            update_name_item ();
            update_battery_item ();
            update_status_item ();
            update_pair_item ();

            indicator.set_menu (menu);

            browse_item.activate.connect (() => {
                device.browse ();
            });
            send_item.activate.connect (() => {
                Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
                "Select file", null, Gtk.FileChooserAction.OPEN,
                "Cancel", Gtk.ResponseType.CANCEL,
                "Select", Gtk.ResponseType.OK
                );
                // TODO:don't know whether kdeconnect support multiple file
                chooser.select_multiple = false;
                if (chooser.run () == Gtk.ResponseType.OK) {
                var url = chooser.get_uri ();
                device.send_file (url);
                }
                chooser.close ();
            });
            pair_item.activate.connect (() => {
                device.request_pair ();
            });
            unpair_item.activate.connect (() => {
                device.unpair ();
            });

            device.charge_changed.connect ((charge) => {
                update_battery_item ();
            });
            device.state_changed.connect ((charge) => {
                update_battery_item ();
            });
            device.pairing_failed.connect (()=>{
                update_pair_item ();
                update_status_item ();
            });
            device.pairing_successful.connect (()=>{
                update_pair_item ();
                update_status_item ();
                update_battery_item ();
            });
            device.reachable_status_changed.connect (()=>{
                update_visibility ();
                update_pair_item ();
                update_status_item ();
            });
            device.unpaired.connect (()=>{
                update_visibility ();
                update_pair_item ();
                update_status_item ();
                update_battery_item ();
            });
        }
        public void device_visibility_changed (bool visible) {
            message ("%s visibilitiy changed to %s", device.name, visible?"true":"false");
            update_visibility ();
            update_name_item ();
            update_battery_item ();
            update_status_item ();
            update_pair_item ();
        }

        private void update_visibility () {
            if (!device.is_reachable ())
                indicator.set_status (AppIndicator.IndicatorStatus.PASSIVE);
            else
                indicator.set_status (AppIndicator.IndicatorStatus.ACTIVE);
        }
        private void update_name_item () {
            name_item.label = device.name;
        }
        private void update_battery_item () {
            battery_item.visible = device.is_paired () && device.is_reachable ();
            this.battery_item.label = "Battery : %d%%".printf(device.battery);
            if (device.is_charging ())
                this.battery_item.label += " (charging)";
        }
        private void update_status_item () {

            if (device.is_reachable ()) {
                if (device.is_paired ())
                    this.status_item.label = "Device Reachable and Paired";
                else
                    this.status_item.label = "Device Reachable but Not Paired";
            } else {
                if (device.is_paired ())
                    this.status_item.label = "Device Paired but not Reachable";
                else
                    // is this even posible?
                    this.status_item.label = "Device Not Reachable and Not Paired";
            }
        }
        private void update_pair_item () {
            var paired = device.is_paired ();
            var reachable = device.is_reachable ();
            pair_item.visible = !paired;
            unpair_item.visible = paired;

            separator.visible = paired;
            browse_item.visible = paired;
            browse_item.sensitive = reachable;
            send_item.visible = paired;
            send_item.sensitive = reachable;
        }
    }
}

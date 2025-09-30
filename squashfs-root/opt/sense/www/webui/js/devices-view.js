const dateFromTimestamp = function(timestamp) {
    return new Date(timestamp * 1000).toLocaleString();
};

class DevicesView {

    constructor()
    {
        this.view = document.getElementById('device-settings');
        this.title = document.getElementById('device-content-title');

        this.deviceListHeader = document.getElementById('device-list-header');

        this.deviceAdd = document.getElementById('device-add');
        this.deviceAddHeader = document.getElementById('device-add-header');
        this.deviceAddDevice = document.getElementById('device-add-device');
        this.deviceAddCancel = document.getElementById('device-add-cancel');
        this.deviceAddSave = document.getElementById('device-add-save');
        this.deviceAddMac = document.getElementById('device-add-mac');

        this.deviceList = document.getElementById('device-list');
        this.deviceListContent = document.getElementById('device-list-content');

        this.detailedSettings = document.getElementById('detailed-settings');
        this.detailedSettingsSave = document.getElementById('detailed-settings-save');
        this.detailedSettingsCancel = document.getElementById('detailed-settings-cancel');
        this.detailedSettingsDelete = document.getElementById('detailed-settings-delete');

        this.deviceName = document.getElementById('detailed-settings-name');
        this.deviceMac = document.getElementById('detailed-settings-mac');
        this.deviceIp = document.getElementById('detailed-settings-ip');
        this.deviceFirst = document.getElementById('detailed-settings-first');
        this.deviceLast = document.getElementById('detailed-settings-last');
        this.deviceProfile = document.getElementById('detailed-settings-profile');
        this.deviceType = document.getElementById('detailed-settings-type');
        this.deviceBrowsing = document.getElementById('detailed-settings-browsing');
        this.deviceTracking = document.getElementById('detailed-settings-tracking');
        this.deviceIot = document.getElementById('detailed-settings-iot');
        this.deviceBlock = document.getElementById('detailed-settings-block');

        this.detailedSettingsCancel.addEventListener('click', () => {
            this.showDeviceList();
        });

        this.deviceAddDevice.addEventListener('click', () => {
            this.showDeviceAdd();
        });

        this.deviceAddCancel.addEventListener('click', () => {
            this.showDeviceList();
        });

        this.deviceAddMac.oninput = () => {
            if (this.deviceAddMac.value.length) {
                this.deviceAddMac.style.boxShadow = 'none';
            }
        };

        this.state = {
            profiles: [],
            devices: []
        };
    }

    show()
    {
        this.showDeviceList();
        this.view.style.display = 'block';
    }

    hide()
    {
        this.view.style.display = 'none';
    }

    showDetailedSettings(mac)
    {
        for (const device of this.state.devices) {
            if (device.mac == mac) {
                this.deviceName.value = device.displayName ? device.displayName : "";
                this.deviceMac.textContent = device.mac;
                this.deviceIp.textContent = device.ip;
                this.deviceProfile.value = device.profile || '';

                if (device.detectedIot == null) {
                    this.deviceType.textContent = "Detecting";
                } else {
                    this.deviceType.textContent = device.detectedIot ? "IoT" : "Personal";
                }

                this.deviceBrowsing.checked = device.browsingProtection;
                this.deviceTracking.checked = device.trackingProtection;
                this.deviceIot.checked = device.iotProtection;
                this.deviceBlock.checked = device.blockInternet;

                this.deviceListContent.style.display = 'none';
                this.deviceAddDevice.style.display = 'none';
                this.detailedSettings.style.display = 'flex';
                this.detailedSettingsSave.style.display = 'flex';
                this.detailedSettingsCancel.style.display = 'flex';
                this.title.textContent = 'Edit device';
                break;
            }
        }
    }

    getDetailedSettings()
    {
        const settings = {};
        settings.mac = this.deviceMac.textContent;
        settings.deviceInfo = {
            displayName: this.deviceName.value,
            profile: this.deviceProfile.value
        };
        settings.deviceSettings = {
            browsingProtection: this.deviceBrowsing.checked,
            trackingProtection: this.deviceTracking.checked,
            iotProtection: this.deviceIot.checked,
            blockInternet: this.deviceBlock.checked
        };

        return settings;
    }

    getNewDeviceMac()
    {
        return this.deviceAddMac.value;
    }

    isMacValid()
    {
        if (!this.deviceAddMac.value.length) {
            this.deviceAddMac.style.boxShadow = '0 0 0.3em red';
            return false;
        }
        return true;
    }

    showDeviceAdd()
    {
        this.deviceAddHeader.style.display = 'flex';
        this.deviceAdd.style.display = 'flex';
        this.deviceAddCancel.style.display = 'flex';
        this.deviceAddSave.style.display = 'flex';
        this.deviceListContent.style.display = 'none';
        this.deviceAddDevice.style.display = 'none';
        this.deviceListHeader.style.display = 'none';
        this.title.textContent = 'Add device';
        document.getElementById('device-add-mac').value = "";
        this.deviceAddMac.style.boxShadow = 'none';
    }


    showDeviceList()
    {
        this.deviceListContent.style.display = 'block';
        this.deviceListHeader.style.display = 'flex';
        this.deviceAddDevice.style.display = 'flex';
        this.detailedSettings.style.display = 'none';
        this.detailedSettingsSave.style.display = 'none';
        this.detailedSettingsCancel.style.display = 'none';
        this.deviceAddHeader.style.display = 'none';
        this.deviceAdd.style.display = 'none';
        this.deviceAddCancel.style.display = 'none';
        this.deviceAddSave.style.display = 'none';
        this.title.textContent = 'Device List';
    }

    setDeviceSettingsSaveOnClick(callback)
    {
        this.detailedSettingsSave.addEventListener('click', callback);
    }

    setDeviceSaveOnClick(callback)
    {
        this.deviceAddSave.addEventListener('click', callback);
    }

    setDeviceDeleteOnClick(callback)
    {
        this.detailedSettingsDelete.addEventListener('click', callback);
    }

    updateDevice(mac, settings, info)
    {
        for (const device of this.state.devices) {
            if (device.mac === mac) {
                if (settings) {
                    device.browsingProtection = settings.browsingProtection;
                    device.trackingProtection = settings.trackingProtection;
                    device.iotProtection = settings.iotProtection;
                    device.blockInternet = settings.blockInternet;
                }
                if (info) {
                    device.displayName = info.displayName;
                    device.profile = info.profile;
                }
                this.updateDeviceList();
                break;
            }
        }
    }

    setProfileList(profiles)
    {
        this.state.profiles = profiles;
        this.updateDeviceList();
    }

    deleteDevice(mac)
    {
        for (const i in this.state.devices) {
            if (this.state.devices[i].mac === mac) {
                this.state.devices.splice(i, 1); // Remove element in place
                this.updateDeviceList();
                break;
            }
        }
    }

    setDeviceList(devices)
    {
        this.state.devices = devices;
        this.updateDeviceList();
    }

    addDevice(device)
    {
        this.state.devices.push(device);
        this.updateDeviceList();
    }

    updateDeviceList()
    {
        this.clearDeviceList();
        this.updateProfileSelect();

        for (const device of this.state.devices) {
            // Header
            const template = document.getElementById('device-template');
            const item = document.importNode(template.content, true);

            const name = item.querySelector('.device-row-name');
            name.textContent = device.displayName;
            const macaddr = item.querySelector('.device-row-mac');
            macaddr.textContent = device.mac;
            const ipaddr = item.querySelector('.device-row-ip');
            ipaddr.textContent = device.ip;

            const selectedProfile = item.querySelector('.device-row-profile');
            let profileName = '';
            for (const profile of this.state.profiles) {
                if (profile.id == device.profile) {
                    profileName = profile.name;
                    break;
                }
            }
            selectedProfile.textContent = profileName;

            const type = item.querySelector('.device-row-type');
            if (device.detectedIot == null) {
                type.textContent = "Detecting";
            } else {
                type.textContent = device.detectedIot ? "IoT" : "Personal";
            }

            const browsing = item.querySelector('.device-row-browsing');
            const tracking = item.querySelector('.device-row-tracking');
            const iot = item.querySelector('.device-row-iot');
            const block = item.querySelector('.device-row-block');
            browsing.textContent = device.browsingProtection ? '✓' : '';
            tracking.textContent = device.trackingProtection ? '✓' : '';
            iot.textContent = device.iotProtection ? '✓' : '';
            block.textContent = device.blockInternet ? '🚫' : '';

            const row = item.querySelector('.device-row');
            const mac = device.mac;

            // Detailed 
            const nameDetailed = item.querySelector('.device-detailed-name');
            nameDetailed.textContent = device.displayName;
            const macaddrDetailed = item.querySelector('.device-detailed-mac');
            macaddrDetailed.textContent = device.mac;
            const ipaddrDetailed = item.querySelector('.device-detailed-ip');
            ipaddrDetailed.textContent = device.ip;

            const selectedProfileDetailed = item.querySelector('.device-detailed-profile');
            selectedProfileDetailed.textContent = profileName;

            const typeDetailed = item.querySelector('.device-detailed-type');
            if (device.detectedIot == null) {
                typeDetailed.textContent = "Detecting";
            } else {
                typeDetailed.textContent = device.detectedIot ? "IoT" : "Personal";
            }

            const last = item.querySelector('.device-detailed-last');
            const first = item.querySelector('.device-detailed-first');
            const epp = item.querySelector('.device-detailed-epp');

            if (device.firstSeen && device.firstSeen.length !== 0) {
                first.textContent = dateFromTimestamp(device.firstSeen);
            } else {
                first.textContent = "N/A";
            }

            if (device.lastSeen && device.lastSeen.length !== 0) {
                last.textContent = dateFromTimestamp(device.lastSeen);
            } else {
                last.textContent = "N/A";
            }

            if (device.eppTimestamp && device.eppTimestamp.length !== 0) {
                epp.textContent = dateFromTimestamp(device.eppTimestamp);
            } else {
                epp.textContent = "N/A";
            }

            const browsingDetailed = item.querySelector('.device-detailed-browsing');
            const trackingDetailed = item.querySelector('.device-detailed-tracking');
            const iotDetailed = item.querySelector('.device-detailed-iot');
            const blockDetailed = item.querySelector('.device-detailed-block');
            browsingDetailed.textContent = device.browsingProtection ? '✓' : '';
            trackingDetailed.textContent = device.trackingProtection ? '✓' : '';
            iotDetailed.textContent = device.iotProtection ? '✓' : '';
            blockDetailed.textContent = device.blockInternet ? '🚫' : '';

            const detectedName = item.querySelector('.device-detected-name');
            detectedName.textContent = device.detectedName;
            const detectedType = item.querySelector('.device-detected-type');
            detectedType.textContent = device.detectedType;
            const detectedModel = item.querySelector('.device-detected-model');
            detectedModel.textContent = device.detectedModel;
            const detectedManufacturer = item.querySelector('.device-detected-manufacturer');
            detectedManufacturer.textContent = device.detectedManufacturer;
            const detectedOs = item.querySelector('.device-detected-os');
            detectedOs.textContent = device.detectedOs;

            const editButton = item.querySelector('.button-edit');
            editButton.addEventListener('click', () => {
                this.showDetailedSettings(mac);
            });

            this.deviceListContent.appendChild(item);
        }

        var acc = document.getElementsByClassName("device-accordion");
        var i;
        
        for (i = 0; i < acc.length; i++) {
          acc[i].addEventListener("click", function() {
            this.classList.toggle("active");
            var panel = this.nextElementSibling;
            if (panel.style.display === "block") {
              panel.style.display = "none";
            } else {
              panel.style.display = "block";
            }
          });
        }
    }

    clearDeviceList()
    {
        this.deviceListContent.innerHTML = ''; // Removes also the event listeners
    }

    updateProfileSelect()
    {
        this.deviceProfile.innerHTML = '';

        // Add empty value as first element
        const empty = document.createElement('option');
        empty.value = '';
        empty.innerHTML = '';
        this.deviceProfile.appendChild(empty);

        for (const profile of this.state.profiles) {
            const newOption = document.createElement('option');
            newOption.value = profile.id;
            newOption.innerHTML = profile.name;
            this.deviceProfile.appendChild(newOption);
        }
    }
}

export default DevicesView;

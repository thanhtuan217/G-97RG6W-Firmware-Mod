import SenseApi from './sense-api.js';
import SettingsView from './settings-view.js';
import DevicesView from './devices-view.js';
import HeaderView from './header-view.js';
import AboutView from './about-view.js';
import ProfilesView from './profiles-view.js';
import EventsView from './events-view.js';

window.addEventListener('load', function() {
    const senseApi = new SenseApi();
    const settingsView = new SettingsView();
    const devicesView = new DevicesView();
    const headerView = new HeaderView();
    const aboutView = new AboutView();
    const profilesView = new ProfilesView();
    const eventsView = new EventsView();

    senseApi.getSystemSettings(function(obj) {
        if (!obj) {
            alert('Error: unable to load settings from the server');
            return;
        }

        settingsView.setEnabled(obj.enabled);
        settingsView.setBrowsingProtection(obj.browsingProtection);
        settingsView.setTrackingProtection(obj.trackingProtection);
        settingsView.setIotProtection(obj.iotProtection);
        settingsView.clearHostName();
        settingsView.loadFilterList(obj.filterList);
        settingsView.sortFilterList();
        settingsView.setFilterListAllSelected(false);
    });

    senseApi.getLicenseStatus(function(obj) {
        let msg = "License server is temporarily unavailable. Please try again later.";
        if (obj) {
            msg = obj.valid ? "valid" : "not valid";
        }

        aboutView.setLicenseStatus(msg);
    });

    senseApi.getDeviceList(function(obj) {
        if (!obj) {
            alert('Error: unable to load devices list from the server');
            return;
        }
        devicesView.setDeviceList(obj.devices); // The same array reference is used by devices and profiles view
        profilesView.setDeviceList(obj.devices);

        for (const device of obj.devices) {
            senseApi.getDeviceSettings(device.mac, function(deviceSettings) {
                if (deviceSettings) {
                    devicesView.updateDevice(device.mac, deviceSettings);
                }
            });
        }
    });

    senseApi.getProfileList(function(obj) {
        if (!obj) {
            alert('Error: unable to load profile list from the server');
            return;
        }
        profilesView.setProfileList(obj.profiles); // The same array reference is used by devices and profiles view
        devicesView.setProfileList(obj.profiles);

        for (const profile of obj.profiles) {
            senseApi.getProfileSettings(profile.id, function(profileSettings) {
                if (profileSettings) {
                    profilesView.updateProfile(profile.id, profileSettings);
                }
            });
        }
    });

    senseApi.getEvents(function(obj) {
        if (obj) {
            eventsView.setEvents(obj.events);
        } else {
            alert('Error: unable to load events from the server');
        }
    });

    senseApi.getCounters(function(obj) {
        if (obj) {
            eventsView.setCounters(obj);
        } else {
            alert('Error: unable to load counters from the server');
        }
    });

    senseApi.getRouterInfo(function(obj) {
        if (!obj) {
            alert('Error: unable to load privacy settings from the server');
            return;
        }

        settingsView.setPrivacy(obj.personal_data_consent);
        aboutView.setClientId(obj.uuid);
    });

    senseApi.getVersion(function(versionText) {
        if (!versionText) {
            alert('Error: unable to load version from the server');
            return;
        }
        settingsView.setVersion(versionText);
        aboutView.setVersion(versionText);
    });

    senseApi.getRouterId(function(id) {
        if (!id) {
            alert('Error: unable to load router id from the server');
            return;
        }
        aboutView.setRouterId(id);
    });

    headerView.setDevicesOnClick(function() {
        devicesView.show();
        settingsView.hide();
        profilesView.hide();
        eventsView.hide();
        aboutView.hide();
        headerView.setDevicesActive();
    });
    headerView.setSettingsOnClick(function() {
        devicesView.hide();
        settingsView.show();
        profilesView.hide();
        eventsView.hide();
        aboutView.hide();
        headerView.setSettingsActive();
    });
    headerView.setProfilesOnClick(function() {
        devicesView.hide();
        settingsView.hide();
        profilesView.show();
        eventsView.hide();
        aboutView.hide();
        headerView.setProfilesActive();
    });
    headerView.setEventsOnClick(function() {
        devicesView.hide();
        settingsView.hide();
        profilesView.hide();
        eventsView.show();
        aboutView.hide();
        headerView.setEventsActive();
    });
    headerView.setAboutOnClick(function() {
        devicesView.hide();
        settingsView.hide();
        profilesView.hide();
        eventsView.hide();
        aboutView.show();
        headerView.setAboutActive();
    });
    devicesView.show();
    settingsView.hide();
    profilesView.hide();
    eventsView.hide();
    aboutView.hide();
    headerView.setDevicesActive();

    settingsView.setEnabledOnClick(function() {
        const obj = settingsView.getSystemSettings();
        obj.enabled = !obj.enabled; // Negation
        settingsView.setEnabled(obj.enabled);
        senseApi.setSystemSettings(obj, function(status) {
            if (!status) {
                alert('Error: Unable to set system settings to the server');
            }
        });
    });

    settingsView.setBrowsingProtectionOnClick(function() {
        const obj = settingsView.getSystemSettings();
        obj.browsingProtection = !obj.browsingProtection; // Negation
        settingsView.setBrowsingProtection(obj.browsingProtection);
        senseApi.setSystemSettings(obj, function(status) {
            if (!status) {
                alert('Error: Unable to set system settings to the server');
            }
        });
    });

    settingsView.setTrackingProtectionOnClick(function() {
        const obj = settingsView.getSystemSettings();
        obj.trackingProtection = !obj.trackingProtection; // Negation
        settingsView.setTrackingProtection(obj.trackingProtection);
        senseApi.setSystemSettings(obj, function(status) {
            if (!status) {
                alert('Error: Unable to set system settings to the server');
            }
        });
    });

    settingsView.setIotProtectionOnClick(function() {
        const obj = settingsView.getSystemSettings();
        obj.iotProtection = !obj.iotProtection; // Negation
        settingsView.setIotProtection(obj.iotProtection);
        senseApi.setSystemSettings(obj, function(status) {
            if (!status) {
                alert('Error: Unable to set system settings to the server');
            }
        });
    });

    settingsView.setPrivacyOnClick(function() {
        const obj = settingsView.getPrivacySettings();
        obj.personal_data_consent = !obj.personal_data_consent; // Negation
        settingsView.setPrivacy(obj.personal_data_consent);
        senseApi.setPrivacySettings(obj, function(status) {
            if (!status) {
                alert('Error: Unable to set privacy settings to the server');
            }
        });
    });

    settingsView.setBlockOnClick(function() {
        const obj = settingsView.getAddBlockedHostObj();

        senseApi.setSystemSettings(obj, function(status, message) {
            if (status) {
                settingsView.addHost(0);
            } else {
                alert('Error: ' + message);
            }
        });
    });

    settingsView.setAllowOnClick(function() {
        const obj = settingsView.getAddAllowedHostObj();

        senseApi.setSystemSettings(obj, function(status, message) {
            if (status) {
                settingsView.addHost(1);
            } else {
                alert('Error: ' + message);
            }
        });
    });

    settingsView.setDeleteOnClick(function() {
        const obj = settingsView.getDeleteSelectedHostObj();

        senseApi.setSystemSettings(obj, function(status) {
            if (status) {
                settingsView.deleteHost();
            } else {
                alert('Error: Unable to set system settings to the server');
            }
        });
    });

    devicesView.setDeviceSettingsSaveOnClick(function() {
        const settings = devicesView.getDetailedSettings();
        senseApi.setDeviceInfo(settings.mac, settings.deviceInfo, function(status) {
            if (status) {
                senseApi.setDeviceSettings(settings.mac, settings.deviceSettings, function(status) {
                    if (status) {
                        devicesView.updateDevice(settings.mac, settings.deviceSettings, settings.deviceInfo);
                        devicesView.showDeviceList();
                        profilesView.updateProfileList();
                    } else {
                        alert('Error: Unable to set device ' + settings.mac + 'settings to the server');
                    }
                });
            } else {
                alert('Error: Unable to set device ' + settings.mac + ' info to the server');
            }
        });
    });

    devicesView.setDeviceSaveOnClick(function() {
        if (devicesView.isMacValid()) {
            const newDeviceMac = devicesView.getNewDeviceMac();
            senseApi.createDevice(newDeviceMac, function(status, message) {
                if (status) {
                    senseApi.getDeviceSettings(newDeviceMac, function (settings) {
                        devicesView.addDevice({ mac: newDeviceMac });
                        devicesView.updateDevice(newDeviceMac, settings);
                        devicesView.showDeviceList();
                    });
                } else {
                    alert(message);
                }
            });
        }
    });

    devicesView.setDeviceDeleteOnClick(function() {
        const settings = devicesView.getDetailedSettings();
        senseApi.deleteDevice(settings.mac, function(status) {
            if (status) {
                devicesView.deleteDevice(settings.mac);
                devicesView.showDeviceList();
                profilesView.updateProfileList();
            } else {
                alert('Error: Unable to delete device ' + settings.mac + ' from the server');
            }
        });
    });

    profilesView.setFamilyRulesOnClick(function(id, settings) {
        if (!settings.contentFiltering) {
            settings.curfewWeekday.enabled = false; // No curfew if family rules are disabled
            settings.curfewWeekend.enabled = false;
        }
        senseApi.setProfileSettings(id, settings, function(status) {
            if (status) {
                profilesView.updateProfileList();
            } else {
                alert('Error: Unable to set profile settings to the server');
            }
        });
    });

    profilesView.setProfileNewOnClick(function() {
        const newProfile = profilesView.getUniqueProfileName();
        senseApi.createProfile({ name: newProfile }, function(obj) {
            if (obj) {
                senseApi.getProfileSettings(obj.id, function (settings) {
                    profilesView.addProfile(obj);
                    profilesView.updateProfile(obj.id, settings);
                    devicesView.updateDeviceList();
                });
            } else {
                alert('Error: Server is unable to create a new profile');
            }
        });
    });

    profilesView.setProfileDeleteOnClick(function() {
        const id = profilesView.getCurrentProfileId();
        senseApi.deleteProfile(id, function(status) {
            if (status) {
                profilesView.removeProfile(id);
                profilesView.showProfileList();
                devicesView.updateDeviceList();
            } else {
                alert('Error: Server is unable to delete the profile');
            }
        });
    });

    profilesView.setProfileSaveOnClick(function() {
        if (profilesView.isNameValid()) {
            profilesView.saveTimeLimits();
            profilesView.saveCategories();
            const settings = profilesView.getProfileSettings();
            settings.profileSettings.contentFiltering = true; // Family rules automatically enabled on save
            senseApi.setProfileInfo(settings.id, settings.profileInfo, function(status) {
                if (status) {
                    senseApi.setProfileSettings(settings.id, settings.profileSettings, function(status) {
                        if (status) {
                            profilesView.updateProfile(settings.id, settings.profileSettings, settings.profileInfo);
                            profilesView.showProfileList();
                            devicesView.updateDeviceList();
                        } else {
                            alert('Error: Unable to set profile settings to the server');
                        }
                    });
                } else {
                    alert('Error: Unable to set profile info to the server');
                }
            });
        }
    });

    eventsView.setRefreshListOnClick(function() {
        const id = eventsView.getLatestId();
        if (id) {
            senseApi.getEventsSince(id, function(obj) {
                if (obj) {
                    eventsView.addEvents(obj.events);
                }
            });
        } else {
            senseApi.getEvents(function(obj) {
                if (obj) {
                    eventsView.setEvents(obj.events);
                } else {
                    alert('Error: unable to load events from the server');
                }
            });
        }
    });

    eventsView.setRefreshCountersOnClick(function() {
        senseApi.getCounters(function(obj) {
            if (obj) {
                eventsView.setCounters(obj);
            } else {
                alert('Error: unable to load counters from the server');
            }
        });
    });

    eventsView.setDeleteAllOnClick(function () {
        senseApi.deleteEvents(function(status) {
            if (status) {
                eventsView.setEvents([]);
            } else {
                alert('Error: Unable to delete events from the server');
            }
        });
    });

    eventsView.setResetCountersOnClick(function () {
        senseApi.resetCounters(function(status) {
            if (status) {
                eventsView.setCounters({});
            } else {
                alert('Error: Unable to reset counters from the server');
            }
        });
    });
});
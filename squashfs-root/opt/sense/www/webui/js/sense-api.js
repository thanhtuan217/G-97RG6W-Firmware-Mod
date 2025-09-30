const parseResponse = function(resp)
{
    try {
        return JSON.parse(resp);
    } catch (err) {
        console.error('parseResponse(): failed parsing response: ' + err.message);
        return null;
    }
};

class SenseApi {

    constructor()
    {
        this.apiHost = window.location.protocol + '//' + window.location.hostname + ':' + window.location.port;
    }

    getVersion(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/version");

        let response = '';
        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200 && xhr.responseText) {
                console.log('getVersion(): status=' + xhr.status + ', text=' + xhr.statusText);
                response = xhr.responseText;
            } else {
                console.error('getVersion(): failed to get version: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(response);
        };

        xhr.send();
    }

    getRouterId(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/router-id");

        let response = '';
        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200 && xhr.responseText) {
                console.log('getRouterId(): status=' + xhr.status + ', text=' + xhr.statusText);
                response = xhr.responseText;
            } else {
                console.error('getRouterId(): failed to get router id: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(response);
        };

        xhr.send();
    }

    getLicenseStatus(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/license-status");

        let response = '';
        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200 && xhr.responseText) {
                console.log('getLicenseStatus(): status=' + xhr.status + ', text=' + xhr.statusText);
                response = parseResponse(xhr.responseText);
            } else {
                console.error('getLicenseStatus(): failed to get licensing info: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(response);
        };

        xhr.send();
    }

    getSystemSettings(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/settings");

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getSystemSettings(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getSystemSettings(): failed to get system settings: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    setSystemSettings(obj, callback)
    {
        if (!obj) {
            console.error('setDeviceSettings(): invalid system settings object');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("PATCH", this.apiHost + "/api/1/settings");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('setSystemSettings(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('setSystemSettings(): failed to set system settings: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200, xhr.statusText);
        };

        xhr.send(JSON.stringify(obj));
    }

    getRouterInfo(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/router-info");

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getRouterInfo(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getRouterInfo(): failed to get router info: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    setPrivacySettings(obj, callback)
    {
        if (!obj) {
            console.error('setPrivacySettings(): invalid privacy settings object');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("PATCH", this.apiHost + "/api/1/router-info");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('setPrivacySettings(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('setPrivacySettings(): failed to set privacy settings: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send(JSON.stringify(obj));
    }

    getDeviceList(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/devices");

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getDeviceList(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getDeviceList(): failed to get device list: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    getDeviceInfo(mac, callback)
    {
        if (!mac) {
            console.error('getDeviceInfo(): invalid mac address');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/devices/" + mac);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getDeviceInfo(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getDeviceInfo(): failed to get device info: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    setDeviceInfo(mac, obj, callback)
    {
        if (!obj || !mac) {
            console.error('setDeviceSettings(): invalid device mac or info object');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("PATCH", this.apiHost + "/api/1/devices/" + mac);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('setDeviceInfo(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('setDeviceInfo(): failed to set device info: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send(JSON.stringify(obj));
    }

    setDeviceSettings(mac, obj, callback)
    {
        if (!obj || !mac) {
            console.error('setDeviceSettings(): invalid device mac or settings object');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("PATCH", this.apiHost + "/api/1/devices/" + mac + "/settings");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('setDeviceSettings(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('setDeviceSettings(): failed to set device settings: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send(JSON.stringify(obj));
    }

    createDevice(mac, callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("POST", this.apiHost + "/api/1/devices/" + mac);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('createDevice(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('createDevice(): failed to create device: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200, xhr.statusText);
        };

        xhr.send();
    }

    deleteDevice(mac, callback)
    {
        if (!mac) {
            console.error('deleteDevice(): invalid mac address');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("DELETE", this.apiHost + "/api/1/devices/" + mac);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('deleteDevice(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('deleteDevice(): failed to delete device: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send();
    }

    getDeviceSettings(mac, callback)
    {
        if (!mac) {
            console.error('getDeviceSettings(): invalid mac address');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/devices/" + mac + "/settings");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getDeviceSettings(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getDeviceSettings(): failed to get device settings: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    getProfileList(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/profiles");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getProfileList(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getProfileList(): failed to get device settings: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    getProfileSettings(id, callback)
    {
        if (!id) {
            console.error('getProfileSettings(): invalid profile id');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/profiles/" + id + "/settings");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getProfileSettings(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getProfileSettings(): failed to get profile settings: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    setProfileSettings(id, obj, callback)
    {
        if (!obj || !id) {
            console.error('setProfileSettings(): invalid profile id or settings object');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("PATCH", this.apiHost + "/api/1/profiles/" + id + "/settings");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('setProfileSettings(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('setProfileSettings(): failed to set profile settings: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send(JSON.stringify(obj));
    }

    setProfileInfo(id, obj, callback)
    {
        if (!obj || !id) {
            console.error('setProfileInfo(): invalid profile id or info object');
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("PATCH", this.apiHost + "/api/1/profiles/" + id);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('setProfileInfo(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('setProfileInfo(): failed to set profile info: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send(JSON.stringify(obj));
    }

    createProfile(profile, callback)
    {
        if (!profile) {
            console.error('createProfile(): invalid profile object');
        }

        const xhr = new XMLHttpRequest();
        xhr.open("POST", this.apiHost + "/api/1/profiles");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('createProfile(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('createProfile(): failed to create profile: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send(JSON.stringify(profile));
    }

    deleteProfile(id, callback)
    {
        if (!id) {
            console.error('deleteProfile(): invalid profile id');
        }

        const xhr = new XMLHttpRequest();
        xhr.open("DELETE", this.apiHost + "/api/1/profiles/" + id);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('deleteProfile(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('deleteProfile(): failed to delete profile: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send();
    }

    getEvents(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/events");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getEvents(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getEvents(): failed to get events: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    getEventsSince(id, callback)
    {
        if (!id) {
            console.error('getEventsSince(): invalid event id');
        }

        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/events/since/" + id);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200) {
                console.log('getEventsSince(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getEventsSince(): failed to get events: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    deleteEvents(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("DELETE", this.apiHost + "/api/1/events");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('deleteEvents(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('deleteEvents(): failed to delete events: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send();
    }

    getCounters(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", this.apiHost + "/api/1/events/counters");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            let obj = null;
            if (xhr.status == 200 && xhr.responseText) {
                console.log('getCounters(): status=' + xhr.status + ', text=' + xhr.statusText);
                obj = parseResponse(xhr.responseText);
            } else {
                console.error('getCounters(): failed to get counters: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(obj);
        };

        xhr.send();
    }

    resetCounters(callback)
    {
        const xhr = new XMLHttpRequest();
        xhr.open("DELETE", this.apiHost + "/api/1/events/counters");
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');

        xhr.onreadystatechange = function() {
            if (xhr.readyState != 4) return;

            if (xhr.status == 200) {
                console.log('resetCounters(): status=' + xhr.status + ', text=' + xhr.statusText);
            } else {
                console.error('resetCounters(): failed to reset counters: status=' + xhr.status + ', text=' + xhr.statusText);
            }
            callback(xhr.status == 200);
        };

        xhr.send();
    }
}

export default SenseApi;
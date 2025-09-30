const updateHost = function(option, host, value)
{
    const tag = value ? '[ALLOWED]' : '[BLOCKED]';
    option.title = host;
    option.value = value;
    option.text = tag + ' ' + host;
};

class SettingsView {

    constructor()
    {
        this.view = document.getElementById('system-settings');

        this.enabledSwitch = document.getElementById('enabled-switch');
        this.browsingSwitch = document.getElementById('browsing-switch');
        this.trackingSwitch = document.getElementById('tracking-switch');
        this.iotSwitch = document.getElementById('iot-switch');
        this.privacySwitch = document.getElementById('privacy-switch');

        this.filterListSelect = document.getElementById('filterlist');
        this.hostNameText = document.getElementById('host-name');

        this.version = document.getElementById('system-version');

        this.allowHostButton = document.getElementById('allow-host');
        this.blockHostButton = document.getElementById('block-host');
        this.deleteHostButton = document.getElementById('delete-host');
        this.selectAllButton = document.getElementById('select-all-none-host');

        this.titleSwitches = document.getElementById('system-settings-title-switches');
        this.titleFilter = document.getElementById('system-settings-title-filter');
        this.titlePrivacy = document.getElementById('system-settings-title-privacy');

        this.switches = document.getElementById('system-settings-switches');
        this.filter = document.getElementById('system-settings-filter');
        this.privacy = document.getElementById('system-settings-privacy');

        this.titleSwitches.addEventListener('click', () => {
            this.showSwitches();
        });
        this.titleFilter.addEventListener('click', () => {
            this.showFilter();
        });
        this.titlePrivacy.addEventListener('click', () => {
            this.showPrivacy();
        });

        this.selectAllButton.addEventListener('click', () => {
            this.selectAllNoneHost();
        });

        this.state = {
            enabled: false,
            browsing: false,
            tracking: false,
            iot: false,
            privacy: false,
            browsingCallback: null,
            trackingCallback: null,
            iotCallback: null
        };
    }

    show()
    {
        this.showSwitches();
        this.view.style.display = 'block';
    }

    hide()
    {
        this.view.style.display = 'none';
    }

    showSwitches()
    {
        this.switches.style.display = 'block';
        this.filter.style.display = 'none';
        this.privacy.style.display = 'none';

        this.titleSwitches.style.fontWeight = 'bold';
        this.titleFilter.style.fontWeight = 'normal';
        this.titlePrivacy.style.fontWeight = 'normal';

        this.titleSwitches.style.color = '#00baff';
        this.titleFilter.style.color = 'black';
        this.titlePrivacy.style.color = 'black';
    }

    showFilter()
    {
        this.switches.style.display = 'none';
        this.filter.style.display = 'block';
        this.privacy.style.display = 'none';

        this.titleSwitches.style.fontWeight = 'normal';
        this.titleFilter.style.fontWeight = 'bold';
        this.titlePrivacy.style.fontWeight = 'normal';

        this.titleSwitches.style.color = 'black';
        this.titleFilter.style.color = '#00baff';
        this.titlePrivacy.style.color = 'black';
    }

    showPrivacy()
    {
        this.switches.style.display = 'none';
        this.filter.style.display = 'none';
        this.privacy.style.display = 'block';

        this.titleSwitches.style.fontWeight = 'normal';
        this.titleFilter.style.fontWeight = 'normal';
        this.titlePrivacy.style.fontWeight = 'bold';

        this.titleSwitches.style.color = 'black';
        this.titleFilter.style.color = 'black';
        this.titlePrivacy.style.color = '#00baff';
    }

    setEnabledOnClick(callback)
    {
        this.enabledSwitch.addEventListener('click', callback);
    }

    setBrowsingProtectionOnClick(callback)
    {
        this.state.browsingCallback = callback;
        this.browsingSwitch.addEventListener('click', callback);
    }

    setTrackingProtectionOnClick(callback)
    {
        this.state.trackingCallback = callback;
        this.trackingSwitch.addEventListener('click', callback);
    }

    setIotProtectionOnClick(callback)
    {
        this.state.iotCallback = callback;
        this.iotSwitch.addEventListener('click', callback);
    }

    setPrivacyOnClick(callback)
    {
        this.privacySwitch.addEventListener('click', callback);
    }

    removeBrowsingProtectionOnClick()
    {
        this.browsingSwitch.removeEventListener('click', this.state.browsingCallback);
    }

    removeTrackingProtectionOnClick()
    {
        this.trackingSwitch.removeEventListener('click', this.state.trackingCallback);
    }

    removeIotProtectionOnClick()
    {
        this.iotSwitch.removeEventListener('click', this.state.iotCallback);
    }

    setAllowOnClick(callback)
    {
        this.allowHostButton.addEventListener('click', callback);
    }

    setBlockOnClick(callback)
    {
        this.blockHostButton.addEventListener('click', callback);
    }

    setDeleteOnClick(callback)
    {
        this.deleteHostButton.addEventListener('click', callback);
    }

    setVersion(text)
    {
        this.version.innerHTML = text;
    }

    setEnabled(value)
    {
        this.state.enabled = value;
        this.enabledSwitch.src = value ? 'res/toggle_on.svg' : 'res/toggle_off.svg';

        // Disable / enable other switches based on value
        if (value) {
            this.setTrackingProtectionOnClick(this.state.trackingCallback);
            this.setIotProtectionOnClick(this.state.iotCallback);
            this.setBrowsingProtectionOnClick(this.state.browsingCallback);
            this.browsingSwitch.src = this.state.browsing ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
            this.trackingSwitch.src = this.state.tracking ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
            this.iotSwitch.src = this.state.iot ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
        } else {
            this.removeBrowsingProtectionOnClick();
            this.removeTrackingProtectionOnClick();
            this.removeIotProtectionOnClick();
            this.browsingSwitch.src = 'res/toggle_disabled.svg';
            this.trackingSwitch.src = 'res/toggle_disabled.svg';
            this.iotSwitch.src = 'res/toggle_disabled.svg';
        }
    }

    setTrackingProtection(value)
    {
        if (this.state.enabled) {
            this.state.tracking = value;
            this.trackingSwitch.src = value ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
        }
    }

    setIotProtection(value)
    {
        if (this.state.enabled) {
            this.state.iot = value;
            this.iotSwitch.src = value ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
        }
    }

    setBrowsingProtection(value)
    {
        if (this.state.enabled) {
            this.state.browsing = value;
            this.browsingSwitch.src = value ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
        }
    }

    setPrivacy(value)
    {
        this.state.privacy = value;
        this.privacySwitch.src = value ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
    }

    getSystemSettings(excludeSelected = false)
    {
        return {
            enabled: this.state.enabled,
            browsingProtection: this.state.browsing,
            trackingProtection: this.state.tracking,
            iotProtection: this.state.iot,
            filterList: this.getFilterList(excludeSelected)
        };
    }

    getPrivacySettings()
    {
        return { personal_data_consent: this.state.privacy };
    }

    clearHostName()
    {
        this.hostNameText.value = '';
    }

    clearFilterList()
    {
        while (this.filterListSelect.options.length > 0) {
            this.filterListSelect.remove(0);
        }
    }

    setFilterListAllSelected(value)
    {
        for (const option of this.filterListSelect.options) {
            option.selected = value;
        }
    }

    sortFilterList()
    {
        const tmpArray = [];

        for (const option of this.filterListSelect.options) {
            tmpArray.push(option);
        }

        tmpArray.sort(function(a,b){ return (a.title < b.title) ? -1 : 1; });

        this.clearFilterList();

        for (const i in tmpArray) {
            this.filterListSelect.options[i] = tmpArray[i];
        }
    }

    searchHost(host)
    {
        let found = -1;
        for (const i in this.filterListSelect.options) {
            if (this.filterListSelect.options[i].title === host) {
                found = i;
                break;
            }
        }
        return found;
    }

    addHost(value)
    {
        const hostName = this.hostNameText.value;
        if (hostName != '') {
            const index = this.searchHost(hostName);
            if (index >= 0) {
                updateHost(this.filterListSelect.options[index], hostName, value);
            }
            else {
                const option = document.createElement("OPTION");
                updateHost(option, hostName, value);
                this.filterListSelect.options.add(option);
                this.sortFilterList();
            }
            this.clearHostName();
            this.setFilterListAllSelected(false);
        }
    }

    deleteHost()
    {
        let i = this.filterListSelect.options.length;
        while (i--) {
            if (this.filterListSelect.options[i].selected) {
                this.filterListSelect.remove(i);
            }
        }
    }

    getAddAllowedHostObj()
    {
        return this.createSetSystemSettingsObj(1);
    }

    getAddBlockedHostObj()
    {
        return this.createSetSystemSettingsObj(0);
    }

    getDeleteSelectedHostObj()
    {
        return this.getSystemSettings(true);
    }

    createSetSystemSettingsObj(value)
    {
        const hostName = this.hostNameText.value;
        const settings = this.getSystemSettings();

        if (hostName != '') {
            const item = settings.filterList.find(o => o.host == hostName);
            if (item === undefined) {
                settings.filterList.push({
                    "host": hostName,
                    "flag": value
                });
            } else {
                item.host = hostName;
                item.flag = value;
            }
        }

        return settings;
    }

    selectAllNoneHost()
    {
        let selection = 0;

        for (const option of this.filterListSelect.options) {
            selection += option.selected;
        }
        this.setFilterListAllSelected(!selection);
    }

    loadFilterList(filterlist)
    {
        this.clearFilterList();
        if (filterlist) {
            for (const filter of filterlist) {
                const option = document.createElement("OPTION");
                updateHost(option, filter.host, filter.flag);
                this.filterListSelect.options.add(option);
            }
        }
    }

    getFilterList(excludeSelected)
    {
        const filterList = [];
        for (const option of this.filterListSelect.options) {
            if (excludeSelected && option.selected) {
                continue;
            }
            
            filterList.push({
                "host": option.title,
                "flag": parseInt(option.value)
            });
        }
        return filterList;
    }
}

export default SettingsView;
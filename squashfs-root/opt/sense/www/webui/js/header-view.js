class HeaderView {

    constructor()
    {
        this.devices = document.getElementById('header-devices');
        this.settings = document.getElementById('header-settings');
        this.profiles = document.getElementById('header-profiles');
        this.events = document.getElementById('header-events');
        this.about = document.getElementById('header-about');
    }

    setDevicesOnClick(callback)
    {
        this.devices.addEventListener('click', callback);
    }

    setSettingsOnClick(callback)
    {
        this.settings.addEventListener('click', callback);
    }

    setProfilesOnClick(callback)
    {
        this.profiles.addEventListener('click', callback);
    }

    setEventsOnClick(callback)
    {
        this.events.addEventListener('click', callback);
    }

    setAboutOnClick(callback)
    {
        this.about.addEventListener('click', callback);
    }

    setDevicesActive()
    {
        this.devices.style.color = '#00baff';
        this.settings.style.color = 'black';
        this.profiles.style.color = 'black';
        this.events.style.color = 'black';
        this.about.style.color = 'black';
    }

    setSettingsActive()
    {
        this.devices.style.color = 'black';
        this.settings.style.color = '#00baff';
        this.profiles.style.color = 'black';
        this.events.style.color = 'black';
        this.about.style.color = 'black';
    }

    setProfilesActive()
    {
        this.devices.style.color = 'black';
        this.settings.style.color = 'black';
        this.profiles.style.color = '#00baff';
        this.events.style.color = 'black';
        this.about.style.color = 'black';
    }

    setEventsActive()
    {
        this.devices.style.color = 'black';
        this.settings.style.color = 'black';
        this.profiles.style.color = 'black';
        this.events.style.color = '#00baff';
        this.about.style.color = 'black';
    }

    setAboutActive()
    {
        this.devices.style.color = 'black';
        this.settings.style.color = 'black';
        this.profiles.style.color = 'black';
        this.events.style.color = 'black';
        this.about.style.color = '#00baff';
    }
}

export default HeaderView;
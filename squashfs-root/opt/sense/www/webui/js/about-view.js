class AboutView {

    constructor()
    {
        this.view = document.getElementById('about');
        this.version = document.getElementById('about-version');
        this.routerId = document.getElementById('about-router-id');
        this.clientId = document.getElementById('about-client-id');
        this.licenseStatus = document.getElementById('about-license-status');
    }

    show()
    {
        this.view.style.display = 'block';
    }

    hide()
    {
        this.view.style.display = 'none';
    }

    setVersion(version)
    {
        this.version.innerHTML = version;
    }

    setRouterId(id)
    {
        this.routerId.innerHTML = id;
    }

    setClientId(id)
    {
        this.clientId.innerHTML = id;
    }

    setLicenseStatus(status)
    {
        this.licenseStatus.innerHTML = status;
    }
}

export default AboutView;
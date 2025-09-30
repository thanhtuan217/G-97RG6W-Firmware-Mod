const hourStringToSecsFromMidnight = function(string) {
    const hours = parseInt(string.slice(0, -3)); // Remove ':00' from the end of string
    return hours * 3600;
};

class ProfilesView {

    constructor()
    {
        this.view = document.getElementById('profile-settings');
        this.title = document.getElementById('profile-header');
        this.description = document.getElementById('profile-description');
        this.profileList = document.getElementById('profile-list');
        this.timeLimits = document.getElementById('profile-time-limits');
        this.contentFiltering = document.getElementById('profile-content-filtering');
        this.profileDetails = document.getElementById('profile-details');
        this.profileDetailsTitle = document.getElementById('profile-details-title');
        this.profileDetailsDescription = document.getElementById('profile-details-description');
        this.profileName = document.getElementById('profile-name-input');
        this.profileAvatar = document.getElementById('profile-details-avatar');
        this.profileSettingsSave = document.getElementById('profile-settings-save');
        this.profileSettingsCancel = document.getElementById('profile-settings-cancel');
        this.profileSettingsNext = document.getElementById('profile-settings-next');
        this.profileSettingsNew = document.getElementById('profile-settings-new');
        this.profileSettingsDelete = document.getElementById('profile-settings-delete');
        this.profileSettingsSelectAll = document.getElementById('profile-settings-select-all');

        this.weekdayMorningSelect = document.getElementById('weekday-morning-select');
        this.weekdayEveningSelect = document.getElementById('weekday-evening-select');
        this.weekendMorningSelect = document.getElementById('weekend-morning-select');
        this.weekendEveningSelect = document.getElementById('weekend-evening-select');
        this.timeLimitWeekdaySwitch = document.getElementById('time-limit-weekday-switch');
        this.timeLimitWeekendSwitch = document.getElementById('time-limit-weekend-switch');

        this.profileSettingsNext.addEventListener('click', (event) => {
            this.showContentFiltering(event.target.profile);
        });
        this.profileSettingsCancel.addEventListener('click', () => {
            this.showProfileList();
        });
        this.profileSettingsSelectAll.addEventListener('click', () => {
            this.selectAllNoneCategories();
        });

        this.timeLimitWeekdaySwitch.addEventListener('click', (event) => {
            this.enableWeekdaySelection(!event.target.value);
        });
        this.timeLimitWeekendSwitch.addEventListener('click', (event) => {
            this.enableWeekendSelection(!event.target.value);
        });

        this.profileName.oninput = () => {
            if (this.profileName.value.length) {
                this.profileName.style.boxShadow = 'none';
            }
            this.updateAvatar();
        };

        this.categories = [
            { title: 'Adult content', icon: 'res/icons/adult_content.svg', category: 'adult' },
            { title: 'Drugs', icon: 'res/icons/drugs.svg', category: 'drugs'},
            { title: 'Alcohol and tobacco', icon: 'res/icons/alcohol.svg', category: 'alcohol_and_tobacco' },
            { title: 'Disturbing', icon: 'res/icons/disturbing.svg', category: 'disturbing' },
            { title: 'Gambling', icon: 'res/icons/gambling.svg', category: 'gambling' },
            { title: 'Illegal', icon: 'res/icons/illegal.svg', category: 'illegal' },
            { title: 'Illegal downloads', icon: 'res/icons/illegal_downloads.svg', category: 'warez' },
            { title: 'Violence', icon: 'res/icons/violence.svg', category: 'violence' },
            { title: 'Hate', icon: 'res/icons/hate.svg', category: 'hate' },
            { title: 'Weapons', icon: 'res/icons/weapons.svg', category: 'weapons' },
            { title: 'Dating', icon: 'res/icons/dating.svg', category: 'dating' },
            { title: 'Shopping and auctions', icon: 'res/icons/shopping.svg', category: 'shopping' },
            { title: 'Video streaming', icon: 'res/icons/streaming.svg', category: 'streaming_media' },
            { title: 'Social networks', icon: 'res/icons/social_networks.svg', category: 'social_networking' },
            { title: 'Anonymizers', icon: 'res/icons/anonymizers.svg', category: 'anonymizers' },
            { title: 'Unknown', icon: 'res/icons/unknown.svg', category: 'unknown' }
        ];

        /* Generate filter categories */
        this.filterElements = {};
        this.populateCategories();

        this.timeOptionsMorning = ['1:00','2:00','3:00','4:00','5:00','6:00','7:00','8:00','9:00','10:00','11:00','12:00'];
        this.timeOptionsEvening = ['12:00', '13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00'];
        this.populateTimeLimitSelects();

        this.state = {
            devices: [],
            profiles: [],
            currentProfile: null
        };
    }

    show()
    {
        this.showProfileList();
        this.view.style.display = 'block';
    }

    hide()
    {
        this.view.style.display = 'none';
    }

    showProfileList()
    {
        this.state.currentProfile = null;

        this.title.textContent = 'Profiles';
        this.description.style.display = 'none';
        this.profileList.style.display = 'flex';
        this.profileDetails.style.display = 'none';
        this.profileDetailsTitle.style.display = 'none';
        this.profileDetailsDescription.style.display = 'none';
        this.timeLimits.style.display = 'none';
        this.contentFiltering.style.display = 'none';
        this.profileSettingsCancel.style.display = 'none';
        this.profileSettingsSave.style.display = 'none';
        this.profileSettingsNext.style.display = 'none';
        this.profileSettingsNew.style.display = 'flex';
        this.profileSettingsDelete.style.display = 'none';
        this.profileSettingsSelectAll.style.display = 'none';
        this.profileName.style.boxShadow = 'none';
    }

    showContentFiltering(id)
    {
        for (const profile of this.state.profiles) {
            if (profile.id == id) {

                for (const key in this.filterElements) {
                    this.filterElements[key].checked = profile.blockedCategories.includes(key);
                }

                this.profileDetailsTitle.textContent = 'Family Rules - Content filtering';
                this.profileDetailsDescription.textContent = 'Select the types of web content you want to block.';
                this.timeLimits.style.display = 'none';
                this.contentFiltering.style.display = 'flex';
                this.profileSettingsNext.style.display = 'none';
                this.profileSettingsSave.style.display = 'flex';
                this.profileSettingsSelectAll.style.display = 'flex';
                break;
            }
        }
    }

    showTimeLimits(id)
    {
        for (const profile of this.state.profiles) {
            if (profile.id == id) {
                this.state.currentProfile = profile;
                this.profileName.value = profile.name;
                this.profileAvatar.firstChild.textContent = profile.name[0].toUpperCase();

                // Use default values if no values are found (21-7 on weekdays and 22-8 on weekends)
                this.weekdayEveningSelect.value = profile.curfewWeekday.from || hourStringToSecsFromMidnight('21:00');
                this.weekdayMorningSelect.value = profile.curfewWeekday.until || hourStringToSecsFromMidnight('7:00');
                this.weekendEveningSelect.value = profile.curfewWeekend.from || hourStringToSecsFromMidnight('22:00');
                this.weekendMorningSelect.value = profile.curfewWeekend.until || hourStringToSecsFromMidnight('8:00');

                this.enableWeekdaySelection(profile.curfewWeekday.enabled);
                this.enableWeekendSelection(profile.curfewWeekend.enabled);

                this.title.textContent = 'Profile name';
                this.description.style.display = 'none';
                this.profileList.style.display = 'none';
                this.profileDetails.style.display = 'flex';
                this.profileDetailsTitle.textContent = 'Family Rules - Bedtime';
                this.profileDetailsTitle.style.display = 'flex';
                this.profileDetailsDescription.textContent = 'Prevent internet use during night-time.';
                this.profileDetailsDescription.style.display = 'flex';
                this.timeLimits.style.display = 'flex';
                this.contentFiltering.style.display = 'none';
                this.profileSettingsNext.style.display = 'flex';
                this.profileSettingsNext.profile = id; // Inject data into event listener using event.target.profile
                this.profileSettingsCancel.style.display = 'flex';
                this.profileSettingsSave.style.display = 'none';
                this.profileSettingsNew.style.display = 'none';
                this.profileSettingsDelete.style.display = 'flex';
                break;
            }
        }
    }

    updateAvatar()
    {
        this.profileAvatar.firstChild.textContent = this.profileName.value[0].toUpperCase();
    }

    enableWeekdaySelection(value)
    {
        this.timeLimitWeekdaySwitch.value = value;
        this.timeLimitWeekdaySwitch.src = value ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
        this.weekdayMorningSelect.disabled = !value;
        this.weekdayEveningSelect.disabled = !value;
    }

    enableWeekendSelection(value)
    {
        this.timeLimitWeekendSwitch.value = value;
        this.timeLimitWeekendSwitch.src = value ? 'res/toggle_on.svg' : 'res/toggle_off.svg';
        this.weekendMorningSelect.disabled = !value;
        this.weekendEveningSelect.disabled = !value;
    }

    setProfileList(profiles)
    {
        this.state.profiles = profiles;
        this.updateProfileList();
    }

    addProfile(profile)
    {
        this.state.profiles.push(profile);
        this.updateProfileList();
    }

    updateProfile(id, settings, info)
    {
        for (const profile of this.state.profiles) {
            if (profile.id === id) {
                if (settings) {
                    profile.contentFiltering = settings.contentFiltering;
                    profile.curfewWeekday = settings.curfewWeekday;
                    profile.curfewWeekend = settings.curfewWeekend;
                    profile.blockedCategories = settings.blockedCategories;
                }
                if (info) {
                    profile.name = info.name;
                }
                this.updateProfileList();
                break;
            }
        }
    }

    setDeviceList(devices)
    {
        this.state.devices = devices;
        this.updateProfileList();
    }

    removeProfile(id)
    {
        for (const i in this.state.profiles) {
            if (this.state.profiles[i].id === id) {
                this.state.profiles.splice(i, 1); // Remove element in place
                this.updateProfileList();
                break;
            }
        }
    }

    setFamilyRulesOnClick(callback)
    {
        this.state.familyRulesCallback = callback;
    }

    setProfileNewOnClick(callback)
    {
        this.profileSettingsNew.addEventListener('click', callback);
    }

    setProfileSaveOnClick(callback)
    {
        this.profileSettingsSave.addEventListener('click', callback);
    }

    setProfileDeleteOnClick(callback)
    {
        this.profileSettingsDelete.addEventListener('click', callback);
    }

    setContentFiltering(id, value)
    {
        if (this.state.familyRulesCallback) {
            for (const profile of this.state.profiles) {
                if (profile.id == id) {
                    profile.contentFiltering = value;
                    this.state.currentProfile = profile;

                    const obj = this.getProfileSettings();
                    this.state.familyRulesCallback(id, obj.profileSettings);
                    this.state.currentProfile = null;
                    break;
                }
            }
        }
    }

    selectAllNoneCategories()
    {
        let state = false;
        for (const key in this.filterElements) {
            state |= this.filterElements[key].checked;
        }

        for (const key in this.filterElements) {
            this.filterElements[key].checked = !state;
        }
    }

    saveCategories()
    {
        if (this.state.currentProfile) {
            const blockedCategories = [];
            for (const key in this.filterElements) {
                if (this.filterElements[key].checked) {
                    blockedCategories.push(key);
                }
            }

            this.state.currentProfile.blockedCategories = blockedCategories;
        }
    }

    saveTimeLimits()
    {
        if (this.state.currentProfile) {
            this.state.currentProfile.curfewWeekend = {
                enabled: Boolean(this.timeLimitWeekendSwitch.value),
                from: parseInt(this.weekendEveningSelect.value),
                until: parseInt(this.weekendMorningSelect.value)
            };
            this.state.currentProfile.curfewWeekday = {
                enabled: Boolean(this.timeLimitWeekdaySwitch.value),
                from: parseInt(this.weekdayEveningSelect.value),
                until: parseInt(this.weekdayMorningSelect.value)
            };
        }
    }

    getProfileSettings()
    {
        const obj = {};
        if (this.state.currentProfile) {
            obj.id = this.state.currentProfile.id;
            obj.profileInfo = {
                name: this.profileName.value
            };
            obj.profileSettings = {
                contentFiltering: this.state.currentProfile.contentFiltering,
                curfewWeekday: Object.assign({}, this.state.currentProfile.curfewWeekday),
                curfewWeekend: Object.assign({}, this.state.currentProfile.curfewWeekend),
                blockedCategories: this.state.currentProfile.blockedCategories
            };
        }

        return obj;
    }

    getCurrentProfileId()
    {
        return this.state.currentProfile ? this.state.currentProfile.id : '';
    }

    getUniqueProfileName()
    {
        let name = '';
        for (let i = 1; i < 100; i++) {
            let found = false;
            name = 'Profile #' + i;
            for (const profile of this.state.profiles) {
                if (profile.name === name) {
                    found = true;
                }
            }
            if (!found) {
                break;
            }
        }
        return name;
    }

    isNameValid()
    {
        if (!this.profileName.value.length) {
            this.profileName.style.boxShadow = '0 0 0.3em red';
            return false;
        }
        return true;
    }

    updateProfileList()
    {
        this.clearProfileList();

        for (const profile of this.state.profiles) {
            const template = document.getElementById('profile-template');
            const item = document.importNode(template.content, true);

            const avatar = item.querySelector('.profile-avatar');
            avatar.firstChild.textContent = profile.name[0].toUpperCase();

            const devices = item.querySelector('.profile-devices-text');
            let i = 0;
            for (const device of this.state.devices) {
                if (device.profile === profile.id) {
                    const prefix = (i !== 0) ? ', ' : '';
                    devices.textContent += prefix + (device.displayName || device.mac);
                    i++;
                }
            }
            if (!i) {
                devices.textContent = 'none';
            }

            const name = item.querySelector('.profile-name');
            name.textContent = profile.name;

            const toggle = item.querySelector('.profile-family-rules-toggle');
            toggle.src = profile.contentFiltering ? 'res/toggle_on.svg' : 'res/toggle_off.svg';

            const id = profile.id;
            const contentFiltering = profile.contentFiltering;
            toggle.addEventListener('click', () => {
                this.setContentFiltering(id, !contentFiltering);
            });
            const edit = item.querySelector('.profile-button');
            edit.addEventListener('click', () => {
                this.showTimeLimits(id);
            });

            this.profileList.appendChild(item);
        }

        // In case there are no profiles - add a note
        if (this.state.profiles.length === 0) {
            const template = document.getElementById('profile-template');
            const item = document.importNode(template.content, true);

            const row = item.querySelector('.profile-row');
            row.innerHTML = '';
            const dummy = document.createElement('div');
            dummy.textContent = 'No profiles found.';
            dummy.id = 'empty';
            row.appendChild(dummy);

            this.profileList.appendChild(item);
        }
    }

    clearProfileList()
    {
        this.profileList.innerHTML = ''; // Removes also the event listeners
    }

    populateCategories()
    {
        for (const category of this.categories) {
            const template = document.getElementById('category-template');
            const item = document.importNode(template.content, true);

            const checkbox = item.querySelector('.category-checkbox');
            checkbox.id = 'category-' + category.category;
            this.filterElements[category.category] = checkbox;

            const icon = item.querySelector('.category-icon');
            icon.src = category.icon;

            const description = item.querySelector('.category-description');
            description.textContent = category.title;

            this.contentFiltering.appendChild(item);
        }
    }

    populateTimeLimitSelects()
    {
        const selects = document.querySelectorAll('.time-limit-select');

        for (const select of selects) {
            let options = null;
            if (select.classList.contains('morning')) {
                options = this.timeOptionsMorning;
            } else {
                options = this.timeOptionsEvening;
            }
            for (const option of options) {
                const newOption = document.createElement('option');
                newOption.value = hourStringToSecsFromMidnight(option);
                newOption.innerHTML = option;
                select.appendChild(newOption);
            }
        }
    }
}

export default ProfilesView;
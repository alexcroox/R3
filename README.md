
# Arma 3 After Action Replay *Addon* Component

<p>
    <a href="https://github.com/alexcroox/R3/releases/latest">
        <img src="https://img.shields.io/badge/Version-0.1.0-blue.svg" alt="Project Version">
    </a>    

    <a href="https://travis-ci.org/alexcroox/R3">    
        <img src="https://travis-ci.org/alexcroox/R3.svg?branch=master&style=flat-square" alt="Travis build testing">
    </a>
    
    <a href="https://raw.githubusercontent.com/alexcroox/R3/master/LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-red.svg" alt="Project License">
    </a>
</p>

<p>
    <sup><strong>Requires the latest version of <a href="https://github.com/CBATeam/CBA_A3/releases">CBA A3</a><br/></strong></sup>
</p>

Server Side addon for capturing unit movement and behaviour to a database for After Action Replays on a website. 

Being built along side the [web component](https://github.com/alexcroox/R3-Web).

### Install

1. Download the [latest release](https://github.com/alexcroox/R3/releases/latest)
2. Create a folder `/R3Extension/` in `/%appdata%/local/` and create a `config.properties` file with [this template](https://github.com/alexcroox/R3/blob/master/extension/config.properties)
3. Create a MySQL database with [this structure](https://github.com/alexcroox/R3-Web/blob/master/db-template.sql)
4. Enter your db details into `config.properties`
5. Add @R3 to your server startup mod list
6. Host the [web component, follow instructions here](https://github.com/alexcroox/R3-Web)


### Special thanks

ACE3 dev team for providing [coding guidelines](http://ace3mod.com/wiki/development/coding-guidelines.html) and the [project template](https://github.com/acemod/arma-project-template) this was created from.

[ARK] Kami for building the custom db extension

[ARK] Chairbourne for providing CUP source for the vehicle icons

[NRF1] Crazy for working with me on the original AAR as part of the old 5th Rifles mission framework.


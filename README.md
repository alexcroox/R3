
# Arma 3 After Action Replay *Addon* Component

<p>
    <a href="https://github.com/alexcroox/R3/releases/latest">
        <img src="https://img.shields.io/github/release/alexcroox/r3.svg" alt="Project Version">
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

No modifications to your missions required, nothing for clients to download.

Being built along side the [web component](https://github.com/alexcroox/R3-Web) and [tile generation component](https://github.com/alexcroox/R3-Tile-Generator)

Built for Windows or Linux game servers.

### Demo

An exact mirror of this repo [can be viewed here](https://titanmods.xyz/r3/ark/) which contains replays from [ARK Group](http://ark-group.org/)

### Install Windows Server

1. Download the [latest release](https://github.com/alexcroox/R3/releases/latest) to your Windows game server
2. Create a folder `/R3Extension/` in `/%appdata%/local/` and create a `config.properties` file with [this template](https://github.com/alexcroox/R3/blob/master/extension/config.properties)
3. Create a MySQL database (on your web hosting) with [this structure](https://github.com/alexcroox/R3-Web/blob/master/db-template.sql)
4. Enter your db details into `config.properties`
5. Add @R3 to your server startup mod list
6. Host the [web component, follow instructions here](https://github.com/alexcroox/R3-Web)

### Install Linux Server

*Not yet part of the release download, see [issue #15](https://github.com/alexcroox/R3/issues/15)*

1. Download the [latest release](https://github.com/alexcroox/R3/releases/latest) to your Linux game server
2. Create a folder `/home/<User running Arma>/R3Extension` and create a `config.properties` file with [this template](https://github.com/alexcroox/R3/blob/master/extension/config.properties) inside that folder.
3. Create a MySQL database (on your web hosting) with [this structure](https://github.com/alexcroox/R3-Web/blob/master/db-template.sql)
4. Enter your db details into `config.properties`
5. Add @r3 to your server startup mod list (make sure it's lower case for Linux servers)
6. Host the [web component, follow instructions here](https://github.com/alexcroox/R3-Web)

### Special thanks

[ARK] Kami for building the custom db extension and allowing me to ditch extdb!

ACE3 dev team for providing [coding guidelines](http://ace3mod.com/wiki/development/coding-guidelines.html) and the [project template](https://github.com/acemod/arma-project-template) this was created from.

[ARK] Chairbourne for providing CUP source for the vehicle icons

[NRF1] Crazy for working with me on the original AAR as part of the old 5th Rifles mission framework.


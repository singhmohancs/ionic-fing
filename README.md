# Prerequisites for Ionic + Fing

- Install latest node(https://nodejs.org/en/)
```bash
download latest node https://nodejs.org/en/
```
- Install TypeScript
```bash
npm install -g typescript
```
- Install latest ionic and cordova
```bash
npm install -g cordova ionic
```

## Install Dependencies & cordova Plugins

- Navigate to your project
```bash
cd /ionic-fing
```
- Install NPM Dependencies
```bash
npm install
```
- Install iOS or Android platforms(commands are renamed)
```bash
ionic cordova platform add ios
ionic cordova platform add android
```
- Install the FingKit plugin(commands are renamed)
```bash
ionic cordova plugin add ./fingkit
```
## Config Fing
- Go to src/app/app.component.ts
- replace FING_API_KEY with fing API Key
```bash
window.fing.validateLicenseKey("FING_API_KEY", "",
          (result) => {
            console.log('Licence OK: ' + result);
          }, (error) => {
            console.log(error);
          });
```          

## Launch & build application
- Launch in browser
```bash
ionic serve
```
- Launch in Simulator
```bash
ionic cordova run ios --livereload
```
- Build for the target platforms
```bash
ionic cordova build ios
ionic cordova build android
```

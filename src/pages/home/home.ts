import { Component } from '@angular/core';
declare const window: any;

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {
  constructor() {
  }

  scanNetwork(): void {
    if (window.fing) {
      window.fing.networkScan({}, (result) => {
        console.log('received results:');
        console.log(result);
        var jsonResult = JSON.stringify(result);
        alert(jsonResult);
      }, (error) => {
        console.log(error);
        alert(error);
      });
    }
  }

}

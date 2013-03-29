var app = {
    initialize: function() {
        this.bindEvents();
    },
    bindEvents: function() {
        if (navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/)) {
            document.addEventListener("deviceready", this.onDeviceReady, false);
        } else {
            this.onDeviceReady();
        }
    },
    onDeviceReady: function() {
         var db = window.openDatabase("APP", "1.0", "APP data", 1000000);
         db.transaction(this.createTables);
    },
    createTables: function(tx) {
         tx.executeSql('CREATE TABLE IF NOT EXISTS THINGS (id unique, data)');
    }
};

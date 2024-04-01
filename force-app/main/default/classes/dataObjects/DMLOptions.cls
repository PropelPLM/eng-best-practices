public with sharing class DMLOptions {
    public DMLOptions() {}

    public Boolean allOrNone;

    public DMLOptions setAllOrNone(Boolean allOrNoneFlag) {
        this.allOrNone = allOrNoneFlag;
        return this;
    }

    public Database.DMLOptions build() {
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.optAllOrNone = this.allOrNone;
        return dmo;
    }
}

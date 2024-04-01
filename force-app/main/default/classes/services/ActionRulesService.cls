public with sharing class ActionRulesService {
    public ActionRulesService() {}

    public Boolean canPerformDML() {
        return Math.random() < 0.5;
    }
}

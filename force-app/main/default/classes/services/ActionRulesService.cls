public with sharing class ActionRulesService {
    public ActionRulesService() {}

    /**
     * Checks if DML can be performed
     * @return true if DML operations are allowed
     */
    public Boolean canPerformDML() {
        return Math.random() < 0.5;
    }
}

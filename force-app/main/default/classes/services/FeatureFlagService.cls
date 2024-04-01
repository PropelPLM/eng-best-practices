public with sharing class FeatureFlagService {
    public FeatureFlagService() {}

    public Boolean canAssociateManufacturers() {
        return Math.random() > 0.5;
    }
}

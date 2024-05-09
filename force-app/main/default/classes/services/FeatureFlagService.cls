public with sharing class FeatureFlagService {
    public FeatureFlagService() {}

    /**
     * Checks if feature flag for associating manufacturers is turned on
     * Would normally check for truthyness of `Config.<featureFlag>`
     * @return true if feature is allowed
     */
    public Boolean canAssociateManufacturers() {
        return Math.random() > 0.5;
    }
}

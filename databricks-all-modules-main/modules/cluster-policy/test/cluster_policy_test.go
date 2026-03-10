package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestClusterPolicyModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("policy")

	policyDefinition := `{
		"spark_version": {
			"type": "regex",
			"pattern": "^[0-9]+\\.[0-9]+\\.x-.*"
		},
		"autotermination_minutes": {
			"type": "range",
			"minValue": 10,
			"maxValue": 10080
		},
		"data_security_mode": {
			"type": "fixed",
			"value": "USER_ISOLATION"
		}
	}`

	config := common.ModuleTestConfig{
		ModuleName:      "cluster-policy",
		TestDescription: "Tests Databricks cluster policy module",
		RequiredVars: map[string]interface{}{
			"name":       uniqueID,
			"definition": policyDefinition,
		},
		OptionalVars: map[string]interface{}{
			"description": "Test cluster policy created by terratest",
		},
		ExpectedOutputs: []string{
			"id",
			"policy_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestClusterPolicyModuleWithMaxClustersPerUser(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("policy-limit")

	policyDefinition := `{
		"spark_version": {
			"type": "regex",
			"pattern": "^[0-9]+\\.[0-9]+\\.x-.*"
		},
		"autotermination_minutes": {
			"type": "range",
			"minValue": 10,
			"maxValue": 10080
		}
	}`

	config := common.ModuleTestConfig{
		ModuleName:      "cluster-policy",
		TestDescription: "Tests Databricks cluster policy with flexible limits",
		RequiredVars: map[string]interface{}{
			"name":       uniqueID,
			"definition": policyDefinition,
		},
		OptionalVars: map[string]interface{}{
			"description": "Flexible policy - unlimited capacity with security",
			// max_clusters_per_user omitted = unlimited
		},
		ExpectedOutputs: []string{
			"id",
			"policy_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}


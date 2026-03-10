package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestGroupModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("group")

	config := common.ModuleTestConfig{
		ModuleName:      "group",
		TestDescription: "Tests Databricks group module",
		RequiredVars: map[string]interface{}{
			"display_name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"allow_cluster_create":       false,
			"allow_instance_pool_create": false,
			"force": true,
		},
		ExpectedOutputs: []string{
			"id",
			"display_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestGroupModuleWithPermissions(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("group-perms")

	config := common.ModuleTestConfig{
		ModuleName:      "group",
		TestDescription: "Tests Databricks group module with permissions",
		RequiredVars: map[string]interface{}{
			"display_name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"allow_cluster_create":           true,
			"allow_instance_pool_create":     true,
			"databricks_sql_access":          true,
			"workspace_access":               true,
			"force": true,
		},
		ExpectedOutputs: []string{
			"id",
			"display_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}


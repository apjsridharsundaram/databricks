package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestPermissionsModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	clusterID := defaults.ClusterID
	config := common.ModuleTestConfig{
		ModuleName:      "permissions",
		TestDescription: "Tests Databricks permissions module",
		RequiredVars: map[string]interface{}{
			"cluster_id": clusterID,
		},
		OptionalVars: map[string]interface{}{
			"access_control_list": []map[string]interface{}{
				{
					"group_name":       "users",
					"permission_level": "CAN_ATTACH_TO",
				},
			},
		},
		ExpectedOutputs: []string{
			"id",
		},
		SkipDestroy: true, // Requires existing cluster
	}

	common.TestModuleWithConfig(t, config)
}

func TestPermissionsModuleMultipleACLs(t *testing.T) {
	config := common.ModuleTestConfig{
		ModuleName:      "permissions",
		TestDescription: "Tests Databricks permissions with multiple ACLs",
		RequiredVars: map[string]interface{}{
			"notebook_path": "/Users/test/notebook",
		},
		OptionalVars: map[string]interface{}{
			"access_control_list": []map[string]interface{}{
				{
					"group_name":       "users",
					"permission_level": "CAN_READ",
				},
				{
					"group_name":       "admins",
					"permission_level": "CAN_MANAGE",
				},
			},
		},
		ExpectedOutputs: []string{
			"id",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}


package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestGroupMemberModule(t *testing.T) {
	config := common.ModuleTestConfig{
		ModuleName:      "group-member",
		TestDescription: "Tests Databricks group member module",
		RequiredVars: map[string]interface{}{
			"group_id":  "test-group-id",
			"member_id": "test-user-id",
		},
		ExpectedOutputs: []string{
			"id",
		},
		SkipDestroy: true, // Requires existing group and user
	}

	common.TestModuleWithConfig(t, config)
}


package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWorkspaceGroup(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../../infra/terraform/main",

		Vars: map[string]interface{}{
			"additional_groups": []map[string]interface{}{
				{
					"display_name":     "test-group-1",
					"workspace_access": true,
				},
			},
		},

		// Retry up to 3 times on known Databricks API errors
		MaxRetries:         3,
		TimeBetweenRetries: 5,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	groupIDs := terraform.OutputMap(t, terraformOptions, "group_ids")
	assert.NotEmpty(t, groupIDs, "group_ids should not be empty")

	groupNames := terraform.OutputList(t, terraformOptions, "group_names")
	assert.Contains(t, groupNames, "test-group-1", "group_names should contain the test group")
	assert.Contains(t, groupNames, "workspace-admins", "group_names should contain default groups")
	assert.Contains(t, groupNames, "data-engineers", "group_names should contain default groups")
}

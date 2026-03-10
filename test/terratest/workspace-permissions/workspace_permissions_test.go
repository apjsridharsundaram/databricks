package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestWorkspacePermissionsModule validates the workspace-permissions module
// manages object/resource-level permissions within a workspace.
func TestWorkspacePermissionsModule(t *testing.T) {
	t.Parallel()

	// NOTE: This test requires pre-existing workspace objects (notebooks,
	// clusters, jobs, etc.) and group names.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../databricks-all-modules-main/modules/workspace-permissions",

		Vars: map[string]interface{}{
			"permission_assignments": []map[string]interface{}{
				// Replace with actual resource IDs and group names for integration tests
				// {
				// 	"resource_key":   "shared-notebooks",
				// 	"directory_path": "/Shared",
				// 	"access_control_list": []map[string]interface{}{
				// 		{
				// 			"group_name":       "data-engineers",
				// 			"permission_level": "CAN_EDIT",
				// 		},
				// 	},
				// },
			},
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	permissionIDs := terraform.OutputMap(t, terraformOptions, "permission_ids")
	assert.NotNil(t, permissionIDs)
}

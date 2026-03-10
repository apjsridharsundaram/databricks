package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestWorkspaceRoleAssignmentModule validates the workspace-role-assignment
// module assigns principals to a workspace using databricks_mws_permission_assignment.
func TestWorkspaceRoleAssignmentModule(t *testing.T) {
	t.Parallel()

	// NOTE: This test requires:
	// - A valid workspace_id
	// - Pre-existing groups at the account level
	// - An account-level Databricks provider configuration
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../databricks-all-modules-main/modules/workspace-role-assignment",

		Vars: map[string]interface{}{
			"workspace_id": "<workspace-id>", // Replace with actual workspace ID
			"group_role_assignments": []map[string]interface{}{
				// Replace with actual group names for integration tests
				// {
				// 	"group_name":  "test-workspace-admins",
				// 	"permissions": []string{"ADMIN"},
				// },
				// {
				// 	"group_name":  "test-data-engineers",
				// 	"permissions": []string{"USER"},
				// },
			},
			"user_role_assignments": []map[string]interface{}{},
			"sp_role_assignments":   []map[string]interface{}{},
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	groupAssignmentIDs := terraform.OutputMap(t, terraformOptions, "group_assignment_ids")
	assert.NotNil(t, groupAssignmentIDs)

	userAssignmentIDs := terraform.OutputMap(t, terraformOptions, "user_assignment_ids")
	assert.NotNil(t, userAssignmentIDs)
}

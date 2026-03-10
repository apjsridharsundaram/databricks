package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWorkspaceRoleAssignment(t *testing.T) {
	t.Parallel()

	workspaceID := os.Getenv("TEST_WORKSPACE_ID")
	if workspaceID == "" {
		t.Skip("TEST_WORKSPACE_ID not set, skipping integration test")
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "../../../infra/terraform/main",

		Vars: map[string]interface{}{
			"workspace_id": workspaceID,
			"group_role_assignments": []map[string]interface{}{
				{
					"group_name":  "workspace-admins",
					"permissions": []string{"ADMIN"},
				},
			},
			"user_role_assignments": []map[string]interface{}{},
			"sp_role_assignments":   []map[string]interface{}{},
		},

		MaxRetries:         3,
		TimeBetweenRetries: 5,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	groupAssignmentIDs := terraform.OutputMap(t, terraformOptions, "group_assignment_ids")
	assert.NotEmpty(t, groupAssignmentIDs, "group_assignment_ids should not be empty")
}

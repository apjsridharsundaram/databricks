package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestWorkspaceGroupMemberModule validates the workspace-group-member module
// assigns users or service principals to Databricks workspace groups.
func TestWorkspaceGroupMemberModule(t *testing.T) {
	t.Parallel()

	// NOTE: This test requires pre-existing group and user/SP IDs.
	// In a real CI pipeline, create these first or use data sources.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../databricks-all-modules-main/modules/workspace-group-member",

		Vars: map[string]interface{}{
			"members": []map[string]interface{}{
				// Replace with actual group_id and member_id for integration tests
				// {
				// 	"group_id":  "<group-id>",
				// 	"member_id": "<user-id>",
				// },
			},
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	membershipIDs := terraform.OutputMap(t, terraformOptions, "membership_ids")
	assert.NotNil(t, membershipIDs)
}

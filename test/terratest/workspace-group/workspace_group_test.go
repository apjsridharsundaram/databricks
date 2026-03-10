package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestWorkspaceGroupModule validates the workspace-group module creates
// Databricks groups for persona-based RBAC.
func TestWorkspaceGroupModule(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../databricks-all-modules-main/modules/workspace-group",

		Vars: map[string]interface{}{
			"groups": []map[string]interface{}{
				{
					"display_name":   "test-data-engineers",
					"workspace_access": true,
				},
				{
					"display_name":   "test-data-analysts",
					"workspace_access": true,
				},
				{
					"display_name":         "test-workspace-admins",
					"workspace_access":     true,
					"allow_cluster_create": true,
				},
			},
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	groupIDs := terraform.OutputMap(t, terraformOptions, "group_ids")
	assert.Contains(t, groupIDs, "test-data-engineers")
	assert.Contains(t, groupIDs, "test-data-analysts")
	assert.Contains(t, groupIDs, "test-workspace-admins")

	groupNames := terraform.OutputList(t, terraformOptions, "group_names")
	assert.Equal(t, 3, len(groupNames))
}

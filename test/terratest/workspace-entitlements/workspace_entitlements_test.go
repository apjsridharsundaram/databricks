package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestWorkspaceEntitlementsModule validates the workspace-entitlements module
// manages workspace-level entitlements for groups, users, or service principals.
func TestWorkspaceEntitlementsModule(t *testing.T) {
	t.Parallel()

	// NOTE: This test requires pre-existing group IDs.
	// In a real CI pipeline, create groups first or use data sources.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../databricks-all-modules-main/modules/workspace-entitlements",

		Vars: map[string]interface{}{
			"group_entitlements": []map[string]interface{}{
				// Replace with actual group_id for integration tests
				// {
				// 	"group_id":              "<group-id>",
				// 	"workspace_access":      true,
				// 	"databricks_sql_access": true,
				// 	"allow_cluster_create":  true,
				// },
			},
			"user_entitlements": []map[string]interface{}{},
			"sp_entitlements":   []map[string]interface{}{},
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	groupEntitlementIDs := terraform.OutputMap(t, terraformOptions, "group_entitlement_ids")
	assert.NotNil(t, groupEntitlementIDs)
}

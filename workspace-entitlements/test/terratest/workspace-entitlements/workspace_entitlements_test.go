package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWorkspaceEntitlements(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../../infra/terraform/main",

		Vars: map[string]interface{}{
			"group_names_for_entitlements": []string{},
			"named_group_entitlements":     []map[string]interface{}{},
			"direct_group_entitlements":    []map[string]interface{}{},
			"user_entitlements":            []map[string]interface{}{},
			"sp_entitlements":              []map[string]interface{}{},
		},

		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	groupEntitlementIDs := terraform.OutputMap(t, terraformOptions, "group_entitlement_ids")
	assert.NotNil(t, groupEntitlementIDs, "group_entitlement_ids output should exist")
}

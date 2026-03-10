package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWorkspaceGroupMember(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../../infra/terraform/main",

		Vars: map[string]interface{}{
			"group_names": []string{},
			"user_names":  []string{},
			"membership_assignments": []map[string]interface{}{},
			"direct_members":         []map[string]interface{}{},
		},

		MaxRetries:         3,
		TimeBetweenRetries: 5,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	membershipIDs := terraform.OutputMap(t, terraformOptions, "membership_ids")
	assert.NotNil(t, membershipIDs, "membership_ids output should exist")
}

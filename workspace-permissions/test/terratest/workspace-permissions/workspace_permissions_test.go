package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWorkspacePermissions(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../../infra/terraform/main",

		Vars: map[string]interface{}{
			"permission_assignments": []map[string]interface{}{},
		},

		MaxRetries:         3,
		TimeBetweenRetries: 5,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	permissionIDs := terraform.OutputMap(t, terraformOptions, "permission_ids")
	assert.NotNil(t, permissionIDs, "permission_ids output should exist")
}

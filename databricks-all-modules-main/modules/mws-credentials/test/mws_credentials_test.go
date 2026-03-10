package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestMWSCredentialsModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	accountID := defaults.AccountID
	roleARN := defaults.CrossAccountARN

	uniqueID := common.GenerateUniqueTestID("mws-creds")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-credentials",
		TestDescription: "Tests Databricks MWS credentials module (account-level)",
		RequiredVars: map[string]interface{}{
			"account_id":       accountID,
			"credentials_name": uniqueID,
			"role_arn":         roleARN,
		},
		ExpectedOutputs: []string{
			"id",
			"credentials_id",
			"credentials_name",
			"external_id",
		},
		SkipDestroy: true, // Account-level resources require careful handling
	}

	common.TestModuleWithConfig(t, config)
}

func TestMWSCredentialsModuleWithExternalId(t *testing.T) {
	defaults := common.GetTestDefaults()
	accountID := defaults.AccountID
	roleARN := defaults.CrossAccountARN

	uniqueID := common.GenerateUniqueTestID("mws-creds-ext")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-credentials",
		TestDescription: "Tests Databricks MWS credentials with external ID",
		RequiredVars: map[string]interface{}{
			"account_id":       accountID,
			"credentials_name": uniqueID,
			"role_arn":         roleARN,
		},
		ExpectedOutputs: []string{
			"id",
			"credentials_id",
			"credentials_name",
			"external_id",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}


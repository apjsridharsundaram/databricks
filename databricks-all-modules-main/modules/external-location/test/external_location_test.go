package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestExternalLocationModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	extURL := defaults.ExternalLocURL
	credName := defaults.CredentialName

	uniqueID := common.GenerateUniqueTestID("ext-loc")

	config := common.ModuleTestConfig{
		ModuleName:      "external-location",
		TestDescription: "Tests Databricks external location module",
		RequiredVars: map[string]interface{}{
			"name":            uniqueID,
			"url":             extURL,
			"credential_name": credName,
		},
		OptionalVars: map[string]interface{}{
			"comment":         "Test external location",
			"skip_validation": true,
			"force_destroy":   true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"url",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestExternalLocationModuleWithOwner(t *testing.T) {
	defaults := common.GetTestDefaults()
	extURL := defaults.ExternalLocURL
	credName := defaults.CredentialName

	uniqueID := common.GenerateUniqueTestID("ext-loc-owner")

	config := common.ModuleTestConfig{
		ModuleName:      "external-location",
		TestDescription: "Tests Databricks external location with owner",
		RequiredVars: map[string]interface{}{
			"name":            uniqueID,
			"url":             extURL,
			"credential_name": credName,
		},
		OptionalVars: map[string]interface{}{
			"comment":         "External location with owner",
			"owner":           "account users",
			"skip_validation": true,
			"force_destroy":   true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"url",
		},
	}

	common.TestModuleWithConfig(t, config)
}


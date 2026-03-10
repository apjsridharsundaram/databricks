package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestMWSVPCEndpointModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	accountID := defaults.AccountID
	vpceID := defaults.VPCEndpointID

	uniqueID := common.GenerateUniqueTestID("mws-vpce")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-vpc-endpoint",
		TestDescription: "Tests Databricks MWS VPC endpoint module",
		RequiredVars: map[string]interface{}{
			"account_id":          accountID,
			"vpc_endpoint_name":   uniqueID,
			"aws_vpc_endpoint_id": vpceID,
			"aws_account_id":      "000000000000",
			"region":              defaults.AWSRegion,
		},
		ExpectedOutputs: []string{
			"id",
			"vpc_endpoint_id",
			"vpc_endpoint_name",
		},
		SkipDestroy: true, // Account-level resources
	}

	common.TestModuleWithConfig(t, config)
}

func TestMWSVPCEndpointModuleWorkspaceType(t *testing.T) {
	defaults := common.GetTestDefaults()
	accountID := defaults.AccountID
	vpceID := defaults.VPCEndpointID

	uniqueID := common.GenerateUniqueTestID("mws-vpce-ws")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-vpc-endpoint",
		TestDescription: "Tests Databricks MWS VPC endpoint for workspace",
		RequiredVars: map[string]interface{}{
			"account_id":          accountID,
			"vpc_endpoint_name":   uniqueID,
			"aws_vpc_endpoint_id": vpceID,
			"aws_account_id":      "000000000000",
			"region":              defaults.AWSRegion,
		},
		ExpectedOutputs: []string{
			"id",
			"vpc_endpoint_id",
			"vpc_endpoint_name",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}


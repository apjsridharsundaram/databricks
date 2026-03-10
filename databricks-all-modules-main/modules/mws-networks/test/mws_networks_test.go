package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestMWSNetworksModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	uniqueID := common.GenerateUniqueTestID("mws-network")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-networks",
		TestDescription: "Tests Databricks MWS networks module",
		RequiredVars: map[string]interface{}{
			"account_id":   defaults.AccountID,
			"network_name": uniqueID,
			"vpc_id":       defaults.VPCID,
			"subnet_ids":   defaults.SubnetIDs,
			"security_group_ids": []string{
				defaults.SecurityGroupID,
			},
			"vpc_endpoints": map[string]interface{}{
				"dataplane_relay": []string{},
				"rest_api":        []string{},
			},
		},
		ExpectedOutputs: []string{
			"id",
			"network_id",
			"network_name",
			"vpc_id",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

func TestMWSNetworksModuleWithVPCEndpoints(t *testing.T) {
	defaults := common.GetTestDefaults()
	uniqueID := common.GenerateUniqueTestID("mws-network-vpce")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-networks",
		TestDescription: "Tests Databricks MWS networks with VPC endpoints",
		RequiredVars: map[string]interface{}{
			"account_id":   defaults.AccountID,
			"network_name": uniqueID,
			"vpc_id":       defaults.VPCID,
			"subnet_ids":   defaults.SubnetIDs,
			"security_group_ids": []string{
				defaults.SecurityGroupID,
			},
			"vpc_endpoints": map[string]interface{}{
				"dataplane_relay": []string{},
				"rest_api":        []string{},
			},
		},
		ExpectedOutputs: []string{
			"id",
			"network_id",
			"network_name",
			"vpc_id",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

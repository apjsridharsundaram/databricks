package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestIPAccessListModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("ip-list")

	ipAddresses := []string{"1.2.3.4/32", "5.6.7.0/24"}
	currentIP := common.GetOutboundIP()
	if currentIP == "" {
		t.Skip("Skipping: cannot get current outbound IP for ALLOW list test (would lock out runner)")
	}
	ipAddresses = append([]string{currentIP + "/32"}, ipAddresses...)

	config := common.ModuleTestConfig{
		ModuleName:      "ip-access-list",
		TestDescription: "Tests Databricks IP access list module",
		RequiredVars: map[string]interface{}{
			"label":         uniqueID,
			"list_type":     "ALLOW",
			"ip_addresses":  ipAddresses,
		},
		OptionalVars: map[string]interface{}{
			"enabled": true,
		},
		ExpectedOutputs: []string{
			"id",
			"label",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestIPAccessListModuleBlockList(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("ip-block")

	config := common.ModuleTestConfig{
		ModuleName:      "ip-access-list",
		TestDescription: "Tests Databricks IP access list with BLOCK type",
		RequiredVars: map[string]interface{}{
			"label":     uniqueID,
			"list_type": "BLOCK",
			"ip_addresses": []string{
				"10.0.0.0/8",
			},
		},
		OptionalVars: map[string]interface{}{
			"enabled": true,
		},
		ExpectedOutputs: []string{
			"id",
			"label",
		},
	}

	common.TestModuleWithConfig(t, config)
}


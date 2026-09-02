from pathlib import Path
import unittest


ROOT = Path(__file__).parents[1]


class TemplateSafetyTests(unittest.TestCase):
    def test_billable_components_default_off(self):
        main = (ROOT / "infra/main.bicep").read_text()
        self.assertIn("param deployBillableCompute bool = false", main)
        self.assertIn("param deployBastion bool = false", main)
        self.assertIn("param deployAlerts bool = false", main)

    def test_storage_secure_defaults(self):
        storage = (ROOT / "infra/modules/storage.bicep").read_text()
        for control in (
            "allowBlobPublicAccess: false",
            "allowSharedKeyAccess: false",
            "defaultToOAuthAuthentication: true",
            "publicNetworkAccess: 'Disabled'",
            "minimumTlsVersion: 'TLS1_2'",
        ):
            self.assertIn(control, storage)

    def test_governance_has_policy_and_budget(self):
        governance = (ROOT / "infra/subscription/governance.bicep").read_text()
        self.assertIn("Microsoft.Authorization/policyDefinitions", governance)
        self.assertIn("Microsoft.Authorization/policyAssignments", governance)
        self.assertIn("Microsoft.Consumption/budgets", governance)

    def test_no_committed_secret_values(self):
        included = {".bicep", ".bicepparam", ".md", ".sh", ".yml", ".yaml", ".json"}
        text = "\n".join(
            path.read_text(errors="ignore")
            for path in ROOT.rglob("*")
            if path.is_file() and path.suffix in included and "tests" not in path.parts
        )
        self.assertNotIn("clientSecret", text)
        self.assertNotIn("BEGIN PRIVATE KEY", text)


if __name__ == "__main__":
    unittest.main()

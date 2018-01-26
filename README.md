
# Write Secrets

Writes values to Key Vault to allow sharing data between releases.

## Getting Started

This extension solves a problem common to environments deployed through VSTS.  Often, one task or release creates unique values that need to be consumed by other, independent tasks.  These subsequent tasks are not part of the same phase, or even the same release, but they need access to the unique values that were created during the original deployment.

An example of this is the creation of an Azure Service Bus.  The deployment via ARM template can output the connection strings that are needed by applications or web services that use the Service Bus.  However, the deployment of the Service Bus is often independent of the deployment of the applications.  As a result, the VSTS task can't feed the values to the application without manual intervention (i.e. copy and paste).

This extension uses Key Vault as a conduit to connect these two, disparate events.  This extension can be fed outputs from a previous task to store in Key Vault.  The Key Vault secrets can be tagged for selective retrieval by other tasks.

### Limitations with VSTS's native Key Vault integration
Some could argue that VSTS already offers integration with Azure's Key Vault.  However, this integration requires secrets to be added manually to a linked variable library in advance of any deployment.  This limits the usefulness in a dynamic environment where resource creation feeds information to higher layers of the stack.  Secondly, VSTS's integration with Key Vault is limited to reading secrets.  No native VSTS ability exists to write secrets to Key Vault from VSTS.

### Prerequisites
This extension requires an existing Key Vault in an accessible Azure subscription.

## Configuration
This task can be added to a phase or task group to write a specific VSTS variable to the selected Key Vault.  The name of the secret can be specified, and optional tags can be applied to the Key Vault secret.  Tags allow selective retrieval of multiple secrets using the Read Secrets VSTS extension.  Tags should be specified in a format similar to "Environment=Production", where a tag named `Environment` and a value of `Production` will be added to the secret.

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* Craig Boroson 

See also the list of [contributors](https://github.com/cboroson/WriteSecrets/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Pascal Naber at Xpirit for VSTS code samples

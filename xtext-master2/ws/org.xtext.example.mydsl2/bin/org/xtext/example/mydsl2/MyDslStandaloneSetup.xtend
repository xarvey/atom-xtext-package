/*
 * generated by Xtext 2.9.0-SNAPSHOT
 */
package org.xtext.example.mydsl2


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class MyDslStandaloneSetup extends MyDslStandaloneSetupGenerated {

	def static void doSetup() {
		new MyDslStandaloneSetup().createInjectorAndDoEMFRegistration()
	}

}
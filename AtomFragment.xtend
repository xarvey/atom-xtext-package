package org.xtext.example.mydsl1

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.AbstractElement
import org.eclipse.xtext.Alternatives
import org.eclipse.xtext.CharacterRange
import org.eclipse.xtext.EOF
import org.eclipse.xtext.GrammarUtil
import org.eclipse.xtext.Group
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.NegatedToken
import org.eclipse.xtext.ParserRule
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.TerminalRule
import org.eclipse.xtext.UntilToken
import org.eclipse.xtext.Wildcard
import org.eclipse.xtext.util.Strings
import org.eclipse.xtext.util.XtextSwitch
import org.eclipse.xtext.xtext.generator.AbstractGeneratorFragment2
import org.eclipse.xtext.xtext.generator.parser.antlr.AntlrGrammarGenUtil

class AtomFragment extends AbstractGeneratorFragment2 {

	override generate() {
		val configFile = '''
			'scopeName': 'source.xtext'
			'name': 'xtext'
			'fileTypes': [' «language.fileExtensions.join(',')» ']
			'patterns':
			{
				 'match': «collectKeywordsAsRegex()»
				 'name': 'keyword'
			}
		'''

		projectConfig.genericIdeSrc.generateFile(
			'xtext.cson', configFile)
	}

	def collectKeywordsAsRegex() {
		val g = grammar
		val keywords = GrammarUtil.getAllKeywords(g)

		return keywords.filter[ matches('\\w+') ].join(
			'"', // before
			'|', // seperator
			'"' // after
		) [ it ] // how to represent the keyword as a regex (1:1 in this case)
	}

	def collectTerminalsAsRegex() {
		GrammarUtil.allTerminalRules(grammar).map [
			TerminalRuleToRegEx.toRegEx(it)
		].join('\n')
	}

}

// This one is just an example and does NOT produce a valid reg ex but it should clarify the idea
// on how to process terminal rules
class TerminalRuleToRegEx extends XtextSwitch<String> {
	final StringBuilder result

	private  new() {
		this.result=new StringBuilder()
	}

	def static String toRegEx(TerminalRule rule) {
		return new TerminalRuleToRegEx().print(rule)
	}
	def String print(TerminalRule rule) {
		doSwitch(rule.getAlternatives())
		return result.toString()
	}
	override String caseAlternatives(Alternatives object) {
		result.append(Character.valueOf('(').charValue)
		var boolean first=true
		for (AbstractElement elem : object.getElements()) {
			if (!first) result.append(Character.valueOf('|').charValue)
			first=false
			doSwitch(elem)
		}
		result.append(Character.valueOf(')').charValue).append(Strings.emptyIfNull(object.getCardinality()))
		return ""
	}
	override String caseCharacterRange(CharacterRange object) {
		if (!Strings.isEmpty(object.getCardinality())) result.append(Character.valueOf('(').charValue)
		doSwitch(object.getLeft())
		result.append("..")
		doSwitch(object.getRight())
		if (!Strings.isEmpty(object.getCardinality())) {
			result.append(Character.valueOf(')').charValue)
			result.append(Strings.emptyIfNull(object.getCardinality()))
		}
		return ""
	}
	override String defaultCase(EObject object) {
		throw new IllegalArgumentException('''«object.eClass().getName()» is not a valid argument.''')
	}
	override String caseGroup(Group object) {
		if (!Strings.isEmpty(object.getCardinality())) result.append(Character.valueOf('(').charValue)
		var boolean first=true
		for (AbstractElement elem : object.getElements()) {
			if (!first) result.append(Character.valueOf(' ').charValue)
			first=false
			doSwitch(elem)
		}
		if (!Strings.isEmpty(object.getCardinality())) result.append(Character.valueOf(')').charValue)
		result.append(Strings.emptyIfNull(object.getCardinality()))
		return ""
	}
	override String caseKeyword(Keyword object) {
		result.append("'")
		var String value=object.value // TODO escape the string
		result.append(value).append("'")
		result.append(Strings.emptyIfNull(object.getCardinality()))
		return ""
	}
	override String caseWildcard(Wildcard object) {
		result.append(Character.valueOf('.').charValue)
		result.append(Strings.emptyIfNull(object.getCardinality()))
		return ""
	}
	override String caseEOF(EOF object) {
		result.append("EOF")
		result.append(Strings.emptyIfNull(object.getCardinality()))
		return ""
	}
	override String caseTerminalRule(TerminalRule object) {
		result.append(AntlrGrammarGenUtil.getRuleName(object))
		return ""
	}
	override String caseParserRule(ParserRule object) {
		throw new IllegalStateException("Cannot call parser rules that are not terminal rules.")
	}
	override String caseRuleCall(RuleCall object) {
		doSwitch(object.getRule())
		result.append(Strings.emptyIfNull(object.getCardinality()))
		return ""
	}
	override String caseNegatedToken(NegatedToken object) {
		result.append("~(")
		doSwitch(object.getTerminal())
		result.append(")").append(Strings.emptyIfNull(object.getCardinality()))
		return ""
	}
	override String caseUntilToken(UntilToken object) {
		result.append("( options {greedy=false;} : . )*")
		doSwitch(object.getTerminal())
		return ""
	}
}

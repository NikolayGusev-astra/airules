#!/usr/bin/env node

/**
 * AIRules Ontology - Graph Validation
 *
 * Validates dependency graph integrity before commits and pushes.
 * Designed for use in git hooks (pre-commit, pre-push) to ensure code quality.
 *
 * Features:
 * - Cyclic dependency detection (CRITICAL)
 * - Unused exports monitoring (WARNING)
 * - Graph health metrics
 * - Configurable validation rules
 * - Git hook integration
 *
 * Exit codes:
 * 0 - Validation passed
 * 1 - Critical errors found
 */

const fs = require('fs');
const path = require('path');

/**
 * Validate dependency graph report
 */
function validateGraphReport(reportPath, config = {}) {
  // Default configuration
  const defaultConfig = {
    cyclesThreshold: 0,      // No cycles allowed
    unusedThreshold: 10,     // Warning threshold for unused exports
    maxImportsPerFile: 20,   // Warning for too many imports
    staleHours: 24,          // Report older than this is stale
    quiet: false
  };

  const settings = { ...defaultConfig, ...config };

  if (!fs.existsSync(reportPath)) {
    console.error('❌ DEPENDENCIES.json not found');
    console.error(`   Path: ${reportPath}`);
    console.error('\n   💡 Solution:');
    console.error('      Run: node scripts/ontology/analyze-dependencies.js');
    console.error('      Then commit your changes');
    process.exit(1);
  }

  let report;
  try {
    report = JSON.parse(fs.readFileSync(reportPath, 'utf8'));
  } catch (err) {
    console.error('❌ Invalid DEPENDENCIES.json format:', err.message);
    console.error(`   Path: ${reportPath}`);
    console.error('\n   💡 Solution:');
    console.error('      Delete docs/DEPENDENCIES.json');
    console.error('      Run: node scripts/ontology/analyze-dependencies.js');
    process.exit(1);
  }

  if (!settings.quiet) {
    console.log('🔍 AIRules Ontology - Graph Validation');
    console.log('======================================\n');
  }

  let hasCriticalErrors = false;
  let warningCount = 0;
  let errorCount = 0;

  // Validation 1: Cyclic dependencies (CRITICAL)
  if (!settings.quiet) console.log('🔄 Checking cyclic dependencies...');

  const cyclesCount = report.cycles ? report.cycles.length : 0;

  if (cyclesCount > settings.cyclesThreshold) {
    hasCriticalErrors = true;
    errorCount += cyclesCount;

    console.error(`❌ CRITICAL: ${cyclesCount} cyclic dependencies found`);
    console.error('   Cycles are not allowed in the dependency graph');

    if (report.cycles && report.cycles.length > 0) {
      console.error('\n   📋 Detected cycles:');
      report.cycles.forEach((cycle, i) => {
        console.error(`      ${i + 1}. ${cycle.map(id => {
          const node = report.graph.nodes.find(n => n.id === id);
          return node ? path.basename(node.name, path.extname(node.name)) : 'unknown';
        }).join(' → ')}`);
      });
    }

    console.error('\n   💡 How to fix:');
    console.error('      1. Identify circular imports in the files above');
    console.error('      2. Refactor to break the dependency cycle');
    console.error('      3. Use dependency injection or event emitters');
    console.error('      4. Move shared logic to a common module');
  } else {
    if (!settings.quiet) console.log('   ✅ No cyclic dependencies found');
  }

  // Validation 2: Unused exports (WARNING)
  if (!settings.quiet) console.log('\n🗑️ Checking unused exports...');

  const unusedCount = report.unusedExports ? report.unusedExports.length : 0;

  if (unusedCount > settings.unusedThreshold) {
    warningCount += unusedCount;
    console.warn(`⚠️ WARNING: ${unusedCount} unused exports (threshold: ${settings.unusedThreshold})`);

    const showLimit = Math.min(unusedCount, 5);
    report.unusedExports.slice(0, showLimit).forEach(u => {
      const fileName = path.basename(u.file);
      console.warn(`      - ${fileName}: '${u.export}' (line ${u.line})`);
    });

    if (unusedCount > showLimit) {
      console.warn(`      ... and ${unusedCount - showLimit} more`);
    }

    console.warn('\n   💡 Recommendations:');
    console.warn('      - Remove unused exports to reduce bundle size');
    console.warn('      - Add exports to index files if they should be public');
    console.warn('      - Consider if the code is actually needed');
  } else {
    if (!settings.quiet) console.log(`   ✅ Unused exports within threshold (${unusedCount}/${settings.unusedThreshold})`);
  }

  // Validation 3: Graph structure integrity
  if (!settings.quiet) console.log('\n📊 Checking graph structure...');

  if (report.summary) {
    const { totalNodes, totalEdges } = report.summary;

    if (totalNodes === 0) {
      hasCriticalErrors = true;
      errorCount++;
      console.error('❌ CRITICAL: Graph contains no nodes (files)');
      console.error('   The project may have no analyzable files');
    } else if (totalEdges === 0) {
      hasCriticalErrors = true;
      errorCount++;
      console.error('❌ CRITICAL: Graph contains no edges (imports)');
      console.error('   Files may not have any imports or analysis failed');
    } else {
      const avgImports = (totalEdges / totalNodes).toFixed(2);

      if (!settings.quiet) {
        console.log(`   ✅ Graph structure valid`);
        console.log(`      Nodes (files): ${totalNodes}`);
        console.log(`      Edges (imports): ${totalEdges}`);
        console.log(`      Average imports per file: ${avgImports}`);
      }

      // Check for excessive imports
      if (parseFloat(avgImports) > settings.maxImportsPerFile) {
        warningCount++;
        console.warn(`⚠️ WARNING: High average imports per file (${avgImports})`);
        console.warn(`   Consider breaking down files with many dependencies`);
      }
    }
  }

  // Validation 4: Report freshness
  if (!settings.quiet) console.log('\n🕐 Checking report freshness...');

  if (report.timestamp) {
    const reportTime = new Date(report.timestamp);
    const now = new Date();
    const diffMs = now - reportTime;
    const diffHours = diffMs / (1000 * 60 * 60);

    if (diffHours > settings.staleHours) {
      warningCount++;
      console.warn(`⚠️ WARNING: Report is stale (${diffHours.toFixed(1)} hours old)`);
      console.warn(`   Recommended to re-run analysis before committing`);
      console.warn(`   Run: node scripts/ontology/analyze-dependencies.js`);
    } else {
      if (!settings.quiet) console.log(`   ✅ Report is fresh (${diffHours.toFixed(1)} hours old)`);
    }
  }

  // Validation 5: Type nodes integrity (if available)
  if (!settings.quiet) console.log('\n🔧 Checking type definitions...');

  if (report.typeNodes && report.typeNodes.length > 0) {
    const typeNodesCount = report.typeNodes.length;
    const totalNodes = report.summary.totalNodes || 0;

    if (!settings.quiet) {
      console.log(`   ✅ Found ${typeNodesCount} type definition files`);
    }

    // Check if type files have proper exports
    const emptyTypeFiles = report.typeNodes.filter(node => node.exports.length === 0);
    if (emptyTypeFiles.length > 0) {
      warningCount += emptyTypeFiles.length;
      console.warn(`⚠️ WARNING: ${emptyTypeFiles.length} type files have no exports`);
      emptyTypeFiles.slice(0, 3).forEach(file => {
        console.warn(`      - ${file.fileName}`);
      });
    }
  } else {
    if (!settings.quiet) console.log('   ℹ️ No type definition files found');
  }

  // Summary and exit
  console.log('\n' + '='.repeat(60));

  if (hasCriticalErrors) {
    console.error('❌ ONTOLOGY VALIDATION: FAILED');
    console.error(`   Critical errors: ${errorCount}`);
    console.error('   ⚠️ Commit blocked - fix critical issues first');
    console.log('='.repeat(60));
    process.exit(1);
  } else if (warningCount > 0) {
    console.warn('⚠️ ONTOLOGY VALIDATION: PASSED WITH WARNINGS');
    console.warn(`   Warnings: ${warningCount}`);
    console.warn('   ✅ Commit allowed but consider fixing warnings');
    console.log('='.repeat(60));
    process.exit(0);
  } else {
    if (!settings.quiet) {
      console.log('✅ ONTOLOGY VALIDATION: PASSED');
      console.log('   Graph is healthy and ready for commit');
    }
    console.log('='.repeat(60));
    process.exit(0);
  }
}

/**
 * Parse command line arguments
 */
function parseArgs(args) {
  const config = {
    reportPath: path.resolve(__dirname, '..', '..', 'docs', 'DEPENDENCIES.json'),
    cyclesThreshold: 0,
    unusedThreshold: 10,
    maxImportsPerFile: 20,
    staleHours: 24,
    quiet: false
  };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    switch (arg) {
      case '--help':
      case '-h':
        console.log(`
AIRules Ontology Graph Validator

Validates dependency graph integrity for commits and CI/CD.

USAGE:
  node validate-graph.js [options]

OPTIONS:
  --report-path <path>     Path to DEPENDENCIES.json (default: docs/DEPENDENCIES.json)
  --cycles-threshold <n>   Maximum allowed cycles (default: 0)
  --unused-threshold <n>   Warning threshold for unused exports (default: 10)
  --max-imports <n>        Warning threshold for imports per file (default: 20)
  --stale-hours <n>        Hours before report is considered stale (default: 24)
  -q, --quiet              Quiet mode (minimal output)
  -h, --help               Show this help

EXIT CODES:
  0  Validation passed
  1  Critical errors found (commit blocked)

EXAMPLES:
  node scripts/ontology/validate-graph.js
  node scripts/ontology/validate-graph.js --unused-threshold 20
  node scripts/ontology/validate-graph.js --quiet
  node scripts/ontology/validate-graph.js --report-path ./my-report.json

GIT HOOKS:
  # pre-commit hook
  #!/bin/sh
  node scripts/ontology/validate-graph.js --quiet

  # pre-push hook
  #!/bin/sh
  node scripts/ontology/validate-graph.js --cycles-threshold 0 --unused-threshold 5
        `);
        process.exit(0);

      case '--report-path':
        if (i + 1 < args.length) {
          config.reportPath = args[i + 1];
          i++;
        }
        break;

      case '--cycles-threshold':
        if (i + 1 < args.length) {
          config.cyclesThreshold = parseInt(args[i + 1]);
          i++;
        }
        break;

      case '--unused-threshold':
        if (i + 1 < args.length) {
          config.unusedThreshold = parseInt(args[i + 1]);
          i++;
        }
        break;

      case '--max-imports':
        if (i + 1 < args.length) {
          config.maxImportsPerFile = parseInt(args[i + 1]);
          i++;
        }
        break;

      case '--stale-hours':
        if (i + 1 < args.length) {
          config.staleHours = parseInt(args[i + 1]);
          i++;
        }
        break;

      case '-q':
      case '--quiet':
        config.quiet = true;
        break;
    }
  }

  return config;
}

/**
 * Main function
 */
async function main() {
  const config = parseArgs(process.argv.slice(2));

  if (!config.quiet) {
    console.log('🛡️ Ontology Graph Validator');
    console.log('==========================\n');
    console.log('⚙️ Configuration:');
    console.log(`   Report path: ${config.reportPath}`);
    console.log(`   Cycles threshold: ${config.cyclesThreshold}`);
    console.log(`   Unused threshold: ${config.unusedThreshold}`);
    console.log(`   Max imports per file: ${config.maxImportsPerFile}`);
    console.log(`   Stale hours: ${config.staleHours}\n`);
  }

  validateGraphReport(config.reportPath, config);
}

main().catch(err => {
  console.error('❌ Unexpected error:', err.message);
  console.error(err.stack);
  process.exit(1);
});
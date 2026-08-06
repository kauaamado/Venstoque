enum SyncScope { all, customers, products, sales }

enum SyncOutcome { success, partialFailure, offline }

class SyncIssue {
  const SyncIssue({
    required this.operation,
    required this.message,
    required this.isNetworkError,
  });

  final String operation;
  final String message;
  final bool isNetworkError;
}

class SyncReport {
  const SyncReport({
    required this.scope,
    required this.startedAt,
    required this.completedAt,
    required this.pushed,
    required this.received,
    required this.saved,
    required this.deferred,
    required this.issues,
    this.pages = 0,
    this.conflicts = 0,
    this.pendingAfter = 0,
  });

  final SyncScope scope;
  final DateTime startedAt;
  final DateTime completedAt;
  final int pushed;
  final int received;
  final int saved;
  final int deferred;
  final List<SyncIssue> issues;
  final int pages;
  final int conflicts;
  final int pendingAfter;

  Duration get duration => completedAt.difference(startedAt);

  int get failed => issues.length;

  SyncOutcome get outcome {
    if (issues.isEmpty && deferred == 0) return SyncOutcome.success;
    if (issues.isNotEmpty && issues.every((issue) => issue.isNetworkError)) {
      return SyncOutcome.offline;
    }
    return SyncOutcome.partialFailure;
  }
}

class SyncReportBuilder {
  SyncReportBuilder(this.scope) : startedAt = DateTime.now();

  final SyncScope scope;
  final DateTime startedAt;
  int pushed = 0;
  int received = 0;
  int saved = 0;
  int deferred = 0;
  int pages = 0;
  int conflicts = 0;
  int pendingAfter = 0;
  final List<SyncIssue> issues = [];

  SyncReport build() {
    return SyncReport(
      scope: scope,
      startedAt: startedAt,
      completedAt: DateTime.now(),
      pushed: pushed,
      received: received,
      saved: saved,
      deferred: deferred,
      issues: List.unmodifiable(issues),
      pages: pages,
      conflicts: conflicts,
      pendingAfter: pendingAfter,
    );
  }
}

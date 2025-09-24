import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final String description;
  final bool status;
  final String dueDate;
  final Function(bool value) onComplete;
  final String taskId;
  final Function(String taskId)? onEdit;
  final String? priority; // High, Medium, Low
  final String? category;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    required this.taskId,
    required this.onComplete,
    this.onEdit,
    this.priority,
    this.category,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    return _isCompleted() ? const Color(0xFF34D399) : _getPriorityColor();
  }

  Color _getPriorityColor() {
    switch (widget.priority?.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6366F1);
    }
  }

  String _getStatusText() {
    return _isCompleted() ? 'Completed' : 'Pending';
  }

  bool _isCompleted() {
    return widget.status;
  }

  bool _isOverdue() {
    if (widget.dueDate.isEmpty || _isCompleted()) return false;
    try {
      DateTime dueDate = DateTime.parse(widget.dueDate);
      return dueDate.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  String _formatDueDate() {
    if (widget.dueDate.isEmpty) return 'No due date';

    try {
      DateTime dueDate = DateTime.parse(widget.dueDate);
      DateTime now = DateTime.now();
      Duration difference = dueDate.difference(now);

      if (difference.inDays == 0) {
        return 'Due today';
      } else if (difference.inDays == 1) {
        return 'Due tomorrow';
      } else if (difference.inDays > 0) {
        return 'Due in ${difference.inDays} days';
      } else {
        int overdueDays = difference.inDays.abs();
        return 'Overdue by $overdueDays day${overdueDays == 1 ? '' : 's'}';
      }
    } catch (e) {
      return widget.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _isCompleted();
    final statusColor = _getStatusColor();
    final isOverdue = _isOverdue();

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: isCompleted
                      ? statusColor.withOpacity(0.2)
                      : isOverdue
                      ? const Color(0xFFEF4444).withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Left accent indicator
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox
                            Container(
                              margin: const EdgeInsets.only(right: 16, top: 2),
                              child: Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: widget.status,
                                  onChanged: (value) => widget.onComplete(value ?? false),
                                  activeColor: statusColor,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),

                            // Title and content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: isCompleted
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade900,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      decorationColor: statusColor.withOpacity(0.6),
                                      decorationThickness: 2,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Status and priority badges
                                  Row(
                                    children: [
                                      // Status badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isOverdue && !isCompleted
                                              ? const Color(0xFFFEE2E2)
                                              : statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isOverdue && !isCompleted
                                                ? const Color(0xFFEF4444)
                                                : statusColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isCompleted
                                                  ? Icons.check_circle
                                                  : isOverdue
                                                  ? Icons.warning
                                                  : Icons.schedule,
                                              size: 12,
                                              color: isOverdue && !isCompleted
                                                  ? const Color(0xFFEF4444)
                                                  : statusColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isOverdue && !isCompleted
                                                  ? 'Overdue'
                                                  : _getStatusText(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: isOverdue && !isCompleted
                                                    ? const Color(0xFFEF4444)
                                                    : statusColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Priority badge
                                      if (widget.priority != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getPriorityColor().withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _getPriorityColor(),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            widget.priority!.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: _getPriorityColor(),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Edit button - only show when task is not completed
                            if (widget.onEdit != null && !isCompleted)
                              InkWell(
                                onTap: () => widget.onEdit!(widget.taskId),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: Color(0xFF3B82F6),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // Description
                        if (widget.description.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 48),
                            child: Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],

                        // Due date
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isOverdue && !isCompleted
                                      ? const Color(0xFFFEE2E2)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.schedule,
                                  size: 14,
                                  color: isOverdue && !isCompleted
                                      ? const Color(0xFFEF4444)
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDueDate(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isOverdue && !isCompleted
                                      ? const Color(0xFFEF4444)
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Completion overlay
                  if (isCompleted)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.green.withOpacity(0.03),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
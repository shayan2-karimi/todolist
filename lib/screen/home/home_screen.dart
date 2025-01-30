import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todolist/constant.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repasitory/repasitory.dart';
import 'package:todolist/screen/edite/cubit/edite_screen_cubit_cubit.dart';
import 'package:todolist/screen/edite/edit_text_screen.dart';
import 'package:todolist/screen/home/bloc/task_list_bloc.dart';

class HomeScreen extends StatelessWidget {
  final ThemeData themeDataC = ThemeData();

  final String taskNameBox = 'task';

  HomeScreen({super.key});
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final TextTheme textThemeC = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) {
                  return BlocProvider(
                    create: (context) => EditeScreenCubitCubit(
                        Task(), context.read<Repasitory<Task>>()),
                    child: const EditTextScreen(),
                  );
                },
              ),
            );
          },
          label: const Row(
            children: [
              Text('Add New Text'),
              SizedBox(
                width: 8,
              ),
              Icon(
                CupertinoIcons.plus,
                size: 20,
              ),
            ],
          ),
        ),
        body: BlocProvider<TaskListBloc>(
          create: (context) => TaskListBloc(context.read<Repasitory<Task>>()),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 120,
                  color: MyColor.primaryVariantColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'to do list',
                              style: textThemeC.headlineMedium,
                            ),
                            const Icon(
                              CupertinoIcons.share,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 38,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: themeDataC.colorScheme.onPrimary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) {
                              context
                                  .read<TaskListBloc>()
                                  .add(TaskListSearch(value));
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.search),
                              label: Text('Search tasks...'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<Repasitory<Task>>(
                    builder: (context, model, child) {
                      context.read<TaskListBloc>().add(TaskListStarted());
                      return BlocBuilder<TaskListBloc, TaskListState>(
                        builder: (context, state) {
                          if (state is TaskListSuccess) {
                            return TaskList(
                                items: state.items, themeDataC: themeDataC);
                          } else if (state is TaskListEmpty) {
                            return const EmptyState();
                          } else if (state is TaskListLoading ||
                              state is TaskListInitial) {
                            return const CircularProgressIndicator();
                          } else if (state is TaskListError) {
                            return Center(
                              child: Text(state.errorMessage),
                            );
                          } else {
                            throw Exception('state is not valid');
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeDataC,
  });

  final List<Task> items;
  final ThemeData themeDataC;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'today',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: themeDataC.colorScheme.onSurface,
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 3,
                      decoration: BoxDecoration(
                        color: themeDataC.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  elevation: 0,
                  color: const Color(0xffEAEFF5),
                  onPressed: () {
                    context.read<TaskListBloc>().add(TaskListDeleteAll());
                  },
                  child: Text(
                    'Delete All',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeDataC.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          final Task taskData = items[index - 1];
          return TastData(taskData: taskData);
        }
      },
    );
  }
}

class TastData extends StatefulWidget {
  const TastData({
    super.key,
    required this.taskData,
  });

  final Task taskData;

  @override
  State<TastData> createState() => _TastDataState();
}

class _TastDataState extends State<TastData> {
  @override
  Widget build(BuildContext context) {
    final Color colorCP;

    switch (widget.taskData.priority) {
      case Priority.low:
        colorCP = MyColor.lowPriority;
        break;
      case Priority.normal:
        colorCP = MyColor.normalPriority;
        break;
      case Priority.high:
        colorCP = MyColor.highPriority;
        break;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => EditeScreenCubitCubit(
                    widget.taskData, context.read<Repasitory<Task>>()),
                child: const EditTextScreen())));
      },
      onLongPress: () {
        widget.taskData.delete();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
          height: 75,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: MyColor.primaryVariantColor,
                  blurRadius: 2,
                )
              ]),
          child: Row(
            children: [
              CheckBox(
                value: widget.taskData.isCompleted,
                onTap: () {
                  setState(() {
                    widget.taskData.isCompleted = !widget.taskData.isCompleted;
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  widget.taskData.name,
                  style: widget.taskData.isCompleted
                      ? const TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w500,
                        )
                      : const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                ),
              ),
              Container(
                height: 75,
                width: 6,
                decoration: BoxDecoration(
                  color: colorCP,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

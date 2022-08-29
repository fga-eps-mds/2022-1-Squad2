import 'package:college_flow_app/config/design_system/data/colors/colors.dart';
import 'package:college_flow_app/config/design_system/data/spacing/spacing.dart';
import 'package:college_flow_app/core/service_locator_manager.dart';
import 'package:college_flow_app/features/review/list_example.dart';
import 'package:college_flow_app/features/review/presentation/bloc/load_review_list_bloc.dart';
import 'package:college_flow_app/features/review/presentation/widgets/review_card.dart';
import 'package:college_flow_app/features/review/presentation/widgets/subject_card.dart';
import 'package:college_flow_app/shared/base_page.dart';
import 'package:college_flow_app/shared/error_page.dart';
import 'package:college_flow_app/shared/loading_page.dart';
import 'package:college_flow_app/shared/widgets/buttons/flow_button.dart';
import 'package:college_flow_app/shared/widgets/flow_icon.dart';
import 'package:college_flow_app/shared/widgets/gap.dart';
import 'package:college_flow_app/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/review.dart';

class ReviewPageParams {
  final String subjectName;
  final String subjectCode;

  const ReviewPageParams({
    required this.subjectCode,
    required this.subjectName,
  });
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({
    Key? key,
    required this.params,
  }) : super(
          key: key,
        );

  final ReviewPageParams params;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final double _scoreMean = 3.2;

  late final LoadReviewListBloc _loadReviewListBloc;

  @override
  void initState() {
    super.initState();
    _loadReviewListBloc = LoadReviewListBloc(
      getReviewList: ServiceLocatorManager.I.get(),
    );
    _loadReviewListBloc.add(const LoadReviewListEvent.loadList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadReviewListBloc, LoadReviewListState>(
      bloc: _loadReviewListBloc,
      builder: (context, state) {
        return state.when(
          error: () => const ErrorPage(
            description:
                'Erro ao carregar lista de avaliações. Tente novamente mais tarde',
          ),
          loading: () => const LoadingPage(
            description: 'Carregando avaliações',
          ),
          loaded: (reviewList) {
            return Scaffold(
              body: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      const SliverAppBar(
                        floating: true,
                        snap: true,
                        backgroundColor: colorPrimary,
                        elevation: 0,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SubjectCard(
                              reviewScore: _scoreMean,
                              subjectCode: widget.params.subjectCode,
                              subjectName: widget.params.subjectName,
                            ),
                            const VSpacer.xs(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: spacingXXS),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Avaliações',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                  const Divider(
                                    thickness: spacingQuarck,
                                    color: colorSecondary,
                                  ),
                                  const VSpacer.xxs(),
                                  MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: reviewList.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            ReviewCard(
                                              review: reviewList[index],
                                            ),
                                            const VSpacer.xxxs(),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const VSpacer.sm(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: spacingXXS,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FlowButton(
                            label: 'Criar avaliação',
                            suffixIcon: const FlowIcon.editComment(),
                            //TODO(Mauricio-Machado): Navigate to Review Form
                            onTap: () {},
                          ),
                        ),
                      ),
                      const VSpacer.xxs(),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

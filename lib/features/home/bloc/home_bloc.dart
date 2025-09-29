import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pruzi_korak/data/health_data/health_repository.dart';
import 'package:pruzi_korak/data/home/home_repository.dart';
import 'package:pruzi_korak/domain/health/daily_distance.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HealthRepository healthRepository;
  final HomeRepository homeRepository;

  HomeBloc(this.homeRepository, {required this.healthRepository})
    : super(HomeLoading()) {
    on<HomeLoadEvent>(_onLoad);
    on<HomeSilentUpdateEvent>(_onSilentUpdate);
  }

  Future<void> _onLoad(HomeLoadEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());
      await _fetchAndUpdateData(emit);
    } catch (_) {
      emit(const HomeError());
    }
  }

  Future<void> _onSilentUpdate(
    HomeSilentUpdateEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Don't emit loading state here - just update the data
      await _fetchAndUpdateData(emit);
    } catch (_) {
      emit(const HomeError());
    }
  }

  Future<void> _fetchAndUpdateData(Emitter<HomeState> emit) async {
    final syncData = await healthRepository.fetchSyncInfo();
    final today = DateTime.now();

    final syncStartDate = _determineSyncStartDate(syncData, today);
    await _syncHealthData(syncStartDate, today);
    await _loadAndEmitHomeData(emit);
  }

  DateTime _determineSyncStartDate(Map<String, dynamic> syncData, DateTime today) {
    final lastSyncAtStr = syncData['last_sync_at'];
    final lastSignInAtStr = syncData['last_sign_in_at'];

    final lastSyncAt = lastSyncAtStr != null ? DateTime.parse(lastSyncAtStr) : null;
    final lastSignInAt = lastSignInAtStr != null ? DateTime.parse(lastSignInAtStr) : null;

    DateTime syncStart = today;
    if (lastSyncAt != null && lastSignInAt != null) {
      syncStart = lastSyncAt.isAfter(lastSignInAt) ? lastSyncAt : lastSignInAt;
    } else if (lastSyncAt != null) {
      syncStart = lastSyncAt;
    } else if (lastSignInAt != null) {
      syncStart = lastSignInAt;
    }

    return syncStart;
  }

  Future<void> _syncHealthData(DateTime syncStart, DateTime today) async {
    final todayDate = DateTime(today.year, today.month, today.day);
    final syncStartDateOnly = DateTime(syncStart.year, syncStart.month, syncStart.day);

    if (syncStartDateOnly == todayDate) {
      await _syncTodayData(syncStart);
    } else {
      await _syncHistoricalData(syncStart);
    }
  }

  Future<void> _syncTodayData(DateTime syncStart) async {
    final kilometers = await healthRepository.getTodayKilometersSinceLastSync(syncStart);
    await healthRepository.sendTodayDistance(kilometers);
  }

  Future<void> _syncHistoricalData(DateTime syncStart) async {
    final allDistances = await healthRepository.getDailyKilometersFromLastSync(syncStart);
    debugPrint('🏷️ allDistances: $allDistances');

    final lastSignInAtStr = (await healthRepository.fetchSyncInfo())['last_sign_in_at'];
    final lastSignInAt = lastSignInAtStr != null ? DateTime.parse(lastSignInAtStr) : null;

    final filteredDistances = _filterValidDistances(allDistances, lastSignInAt);
    await healthRepository.sendDailyDistances(filteredDistances);
  }

  List<DailyDistance> _filterValidDistances(
      List<DailyDistance> distances, DateTime? lastSignInAt) {
    return distances.where((entry) {
      final dateStr = entry.date;
      final km = entry.totalKilometers;

      final entryDate = DateTime.tryParse(dateStr);
      if (entryDate == null) return false;

      return !(lastSignInAt != null && entryDate.isBefore(lastSignInAt)) && km > 0;
    }).toList();
  }

  Future<void> _loadAndEmitHomeData(Emitter<HomeState> emit) async {
    final response = await homeRepository.getHomeData();
    final myRank = await homeRepository.getMyRank();
    final teamStepsModel = response.teamUserStats;

    final userStepsModel = StepsModel(
      steps: teamStepsModel.userToday,
      totalSteps: teamStepsModel.userTotal,
    );

    final team = StepsModel(
      steps: teamStepsModel.teamToday,
      totalSteps: teamStepsModel.teamTotal,
    );

    emit(
      HomeLoaded(
        userModel: response.user,
        userStepsModel: userStepsModel,
        teamStepsModel: team,
        myRank: myRank,
      ),
    );
  }
}

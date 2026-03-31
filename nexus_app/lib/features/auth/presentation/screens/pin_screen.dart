/// ============================================
/// NEXUS CONTROL - PIN Screen
/// ============================================
/// Pantalla de ingreso/creación de PIN

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/isar_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../domain/entities/user_entity.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final List<String> _pin = [];
  final int _pinLength = 4;
  bool _isSetup = false;
  bool _isParent = true;
  bool _isConfirming = false;
  String _firstPin = '';
  String? _error;
  bool _isLoading = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _isSetup = args['isSetup'] ?? false;
      _isParent = args['isParent'] ?? true;
    }
  }
  
  String get _title {
    if (_isSetup) {
      if (_isConfirming) {
        return AppStrings.pinConfirm;
      }
      return _isParent ? AppStrings.pinCreate : 'Crea tu PIN de acceso';
    }
    return AppStrings.pinTitle;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScanlineOverlay(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                
                // Ícono
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    border: Border.all(
                      color: _error != null 
                          ? AppColors.neonRed 
                          : AppColors.neonCyan,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_error != null 
                            ? AppColors.neonRed 
                            : AppColors.neonCyan).withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isParent ? Icons.admin_panel_settings : Icons.rocket_launch,
                    size: 40,
                    color: _error != null 
                        ? AppColors.neonRed 
                        : AppColors.neonCyan,
                  ),
                )
                    .animate(target: _error != null ? 1 : 0)
                    .shake(hz: 4, duration: 400.ms),
                
                const SizedBox(height: 32),
                
                // Título
                Text(
                  _title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  _isParent ? 'Comandante' : 'Piloto',
                  style: TextStyle(
                    fontSize: 14,
                    color: _isParent ? AppColors.neonMagenta : AppColors.neonCyan,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Indicadores de PIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pinLength, (index) {
                    final isFilled = index < _pin.length;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFilled 
                            ? AppColors.neonCyan 
                            : Colors.transparent,
                        border: Border.all(
                          color: _error != null
                              ? AppColors.neonRed
                              : AppColors.neonCyan,
                          width: 2,
                        ),
                        boxShadow: isFilled ? [
                          BoxShadow(
                            color: AppColors.neonCyan.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ] : null,
                      ),
                    )
                        .animate(target: isFilled ? 1 : 0)
                        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
                  }),
                ),
                
                // Mensaje de error
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.neonRed,
                    ),
                  ),
                ],
                
                const SizedBox(height: 48),
                
                // Teclado numérico
                _buildNumpad(),
                
                const Spacer(),
                
                // Indicador de carga
                if (_isLoading)
                  const CircularProgressIndicator(
                    color: AppColors.neonCyan,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNumpad() {
    return Column(
      children: [
        for (var row = 0; row < 4; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var col = 0; col < 3; col++)
                  _buildKey(row, col),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildKey(int row, int col) {
    final keyLabels = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];
    
    final label = keyLabels[row][col];
    
    if (label.isEmpty) {
      return const SizedBox(width: 80, height: 60);
    }
    
    final isBackspace = label == '⌫';
    
    return GestureDetector(
      onTap: () => _onKeyPressed(label),
      child: Container(
        width: 80,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isBackspace 
                ? AppColors.neonRed.withOpacity(0.3) 
                : AppColors.border,
          ),
        ),
        child: Center(
          child: isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  color: AppColors.neonRed,
                  size: 24,
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
  
  void _onKeyPressed(String key) {
    setState(() {
      _error = null;
    });
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    if (key == '⌫') {
      if (_pin.isNotEmpty) {
        setState(() {
          _pin.removeLast();
        });
      }
    } else {
      if (_pin.length < _pinLength) {
        setState(() {
          _pin.add(key);
        });
        
        // Verificar si el PIN está completo
        if (_pin.length == _pinLength) {
          _processPin();
        }
      }
    }
  }
  
  Future<void> _processPin() async {
    final enteredPin = _pin.join();
    
    if (_isSetup) {
      if (!_isConfirming) {
        // Guardar primer PIN y pedir confirmación
        setState(() {
          _firstPin = enteredPin;
          _isConfirming = true;
          _pin.clear();
        });
      } else {
        // Confirmar que coinciden
        if (enteredPin == _firstPin) {
          await _createUser(enteredPin);
        } else {
          setState(() {
            _error = 'Los códigos no coinciden';
            _pin.clear();
            _isConfirming = false;
            _firstPin = '';
          });
          HapticFeedback.heavyImpact();
        }
      }
    } else {
      // Verificar PIN existente
      await _verifyPin(enteredPin);
    }
  }
  
  Future<void> _createUser(String pin) async {
    setState(() => _isLoading = true);
    
    try {
      final pinHash = _hashPin(pin);
      final isar = IsarService.instance;
      
      UserEntity user;
      if (_isParent) {
        user = UserEntity.parent(name: 'Comandante', pinHash: pinHash);
      } else {
        user = UserEntity.child(name: 'Piloto', dailyTimeMinutes: 60);
        user.pinHash = pinHash;
      }
      
      await isar.writeTxn(() async {
        await isar.userEntitys.put(user);
      });
      
      // Actualizar estado global
      ref.read(currentUserProvider.notifier).setUser(user);
      
      if (!mounted) return;
      
      // Navegar según rol
      if (_isParent) {
        Navigator.of(context).pushReplacementNamed('/parent');
      } else {
        Navigator.of(context).pushReplacementNamed('/hud');
      }
    } catch (e) {
      setState(() {
        _error = 'Error al crear usuario';
        _pin.clear();
        _isLoading = false;
      });
    }
  }
  
  Future<void> _verifyPin(String pin) async {
    setState(() => _isLoading = true);
    
    try {
      final pinHash = _hashPin(pin);
      final isar = IsarService.instance;
      
      // Buscar usuario con ese PIN
      final users = await isar.userEntitys.getAll([]);
      final matchingUser = users.where((u) => u != null && u.pinHash == pinHash).firstOrNull;
      
      if (matchingUser != null) {
        // Actualizar estado global
        ref.read(currentUserProvider.notifier).setUser(matchingUser);
        
        if (!mounted) return;
        
        // Navegar según rol
        if (matchingUser.role == UserRole.parent) {
          Navigator.of(context).pushReplacementNamed('/parent');
        } else {
          Navigator.of(context).pushReplacementNamed('/hud');
        }
      } else {
        setState(() {
          _error = AppStrings.pinError;
          _pin.clear();
          _isLoading = false;
        });
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      setState(() {
        _error = 'Error al verificar';
        _pin.clear();
        _isLoading = false;
      });
    }
  }
  
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin + 'nexus_salt');
    return sha256.convert(bytes).toString();
  }
}
